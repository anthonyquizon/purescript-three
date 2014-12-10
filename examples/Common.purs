module Examples.Common where

import           Control.Monad.Eff
import           Control.Monad.Eff.Ref
import           Data.Array
import           DOM
import qualified Graphics.Three.Renderer as Renderer
import qualified Graphics.Three.Material as Material
import qualified Graphics.Three.Geometry as Geometry
import qualified Graphics.Three.Scene    as Scene
import qualified Graphics.Three.Camera   as Camera
import qualified Graphics.Three.Object3D as Object3D
import           Graphics.Three.Util
import           Graphics.Three.Types     
import           Control.Monad.State.Trans
import           Data.Tuple
import qualified Math           as Math

import Debug.Trace

data Context = Context {
          renderer  :: Renderer.Renderer 
        , scene     :: Scene.Scene
        , camera    :: Camera.CameraInstance
        --TODO objects
    }

type Event = {
          x :: Number
        , y :: Number
    }

type Dimensions = {
        width :: Number 
      , height :: Number
    }

context :: Renderer.Renderer -> 
           Scene.Scene -> 
           Camera.CameraInstance -> 
           Context
context r s c = Context {
          renderer: r
        , scene:    s
        , camera:   c
    }

newtype Pos = Pos {
          x :: Number
        , y :: Number
    }

pos :: Number -> Number -> Pos
pos x y = Pos {
          x: x
        , y: y
    }

instance showPos :: Show Pos where
    show (Pos p) = 
        "x: " ++ show p.x ++ ", y: " ++ show p.y

newtype StateRef = StateRef {
          frame :: Number
        , pos   :: Pos
        , prev  :: Pos
    }

instance showStateRef :: Show StateRef where
    show (StateRef s) = 
        "frame: " ++ show s.frame ++ "\n" ++
        "pos: "   ++ show s.pos   ++ "\n" ++
        "prev: "  ++ show s.prev  ++ "\n"

stateRef :: Number -> Pos -> Pos -> StateRef
stateRef f p pv = StateRef {
          frame: f
        , pos: p
        , prev: pv
    }

initStateRef :: StateRef
initStateRef = stateRef 0 nPos nPos
    where
        nPos = pos 0 0

gridList :: forall a. Number -> Number -> (Number -> Number -> a) -> [a]
gridList n m f = concatMap (\i -> map (\j -> f i j) (0..m-1)) (0..n-1)

doAnimation :: forall eff. ThreeEffN eff Unit -> ThreeEffN eff Unit
doAnimation animate = do
    animate
    requestAnimationFrame $ doAnimation animate

updateCamera :: Camera.CameraInstance -> Dimensions -> ThreeEff Unit
updateCamera (Camera.PerspectiveInstance camera) dims = do
    Camera.setAspect camera $ dims.width / dims.height 
    Camera.updateProjectionMatrix camera

updateCamera (Camera.OrthographicInstance camera) dims = do
    Camera.updateOrthographic camera (dims.width/(-2)) (dims.width/(2)) 
                                     (dims.height/2)   (dims.height/(-2))--}
    Camera.updateProjectionMatrix camera

renderContext :: forall eff. Context -> ThreeEffN eff Unit
renderContext (Context c) = do
    case c.camera of
        Camera.PerspectiveInstance camera  -> Renderer.render c.renderer c.scene camera
        Camera.OrthographicInstance camera -> Renderer.render c.renderer c.scene camera

onResize :: forall eff. Context -> Event -> Eff (dom :: DOM, three :: Three | eff) Unit
onResize (Context c) _ = do
    window <- getWindow
    dims   <- nodeDimensions window

    updateCamera c.camera dims

    Renderer.setSize c.renderer dims.width dims.height

createCameraInsance :: Camera.CameraType -> Scene.Scene -> Dimensions -> ThreeEff Camera.CameraInstance
createCameraInsance Camera.Perspective scene dims = do
    camera <- Camera.createPerspective 45 (dims.width / dims.height) 1 1000
    setupCamera scene camera

    return $ Camera.PerspectiveInstance camera
createCameraInsance Camera.Orthographic scene dims = do
    camera <- Camera.createOrthographic (dims.width/(-2)) (dims.width/(2)) 
                                        (dims.height/2) (dims.height/(-2)) 
                                        1 1000
    setupCamera scene camera
    return $ Camera.OrthographicInstance camera

setupCamera :: forall a eff. (Object3D.Object3D a, Camera.Camera a) => Scene.Scene -> a -> ThreeEffN eff Unit
setupCamera scene camera = do
    Scene.addObject scene camera
    Object3D.setPosition camera 0 0 500
    return unit

initContext :: forall eff. Camera.CameraType -> Eff (trace :: Trace, dom :: DOM, three :: Three | eff) Context
initContext cameraType = do
    window   <- getWindow
    dims     <- nodeDimensions window
    renderer <- Renderer.createWebGL {antialias: true}
    scene    <- Scene.create
    camera   <- createCameraInsance cameraType scene dims

    let ctx = context renderer scene camera

    Renderer.setSize renderer dims.width dims.height
    Renderer.appendToDomByID renderer "container"

    addEventListener window "resize" $ onResize ctx
    return ctx
    


unsafePrint :: forall eff a. a -> Eff eff Unit
unsafePrint = fpi ["a", ""] "console.log(a)"

getWindow :: forall eff. Eff (dom :: DOM | eff) Node
getWindow = ffi [""] "window"

getElementsByTagName :: forall eff. String -> Eff (dom :: DOM | eff) Node
getElementsByTagName = ffi ["name", ""] "document.getElementsByTagName(name)[0]"

nodeDimensions :: forall eff. Node -> Eff eff Dimensions
nodeDimensions = ffi ["node", ""]
    """ { 
            width: node.innerWidth ? node.innerWidth : node.width, 
            height: node.innerHeight ? node.innerHeight : node.height
        }
    """

addEventListener :: forall eff1 eff2. Node -> String -> (Event -> Eff eff1 Unit) -> Eff (dom :: DOM | eff2) Unit
addEventListener = fpi ["node", "name", "callback", ""] 
    """ node.addEventListener(name, function(e) {
            callback(e)();
        })
    """

requestAnimationFrame :: forall eff. Eff eff Unit -> Eff eff Unit
requestAnimationFrame = fpi ["callback", ""] "window.requestAnimationFrame(callback)"

