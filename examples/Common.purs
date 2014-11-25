module Examples.Common where

import           Control.Monad.Eff
import           Control.Monad.Eff.Ref
import           DOM
import qualified Graphics.Three.Renderer    as Renderer
import qualified Graphics.Three.Material    as Material
import qualified Graphics.Three.Geometry    as Geometry
import qualified Graphics.Three.Scene       as Scene
import qualified Graphics.Three.Scene.Object3D.Camera      as Camera
import qualified Graphics.Three.Scene.Object3D.Mesh as Mesh
import           Graphics.Three.Util
import           Graphics.Three.Types     
import           Control.Monad.State.Trans
import           Data.Tuple
import qualified Math           as Math

import Debug.Trace


newtype Context = Context {
          renderer :: Renderer.Renderer 
        , scene    :: Scene.Scene
        , camera   :: Camera.Camera
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
           Camera.Camera -> 
           Context
context r s c = Context {
          renderer: r
        , scene:    s
        , camera:   c
    }

newtype ContextState eff a = ContextState (StateT Context (Eff (three :: Three | eff)) a)

runContextState :: forall eff a. ContextState eff a -> Context -> (Eff (three :: Three | eff)) a
runContextState (ContextState ctxState) c = evalStateT ctxState c

doAnimation :: forall eff. Eff (three :: Three | eff) Unit -> Eff (three :: Three | eff) Unit
doAnimation animate = do
    animate
    requestAnimationFrame $ doAnimation animate

onResize :: forall eff. Context -> Event -> Eff (dom :: DOM, three :: Three | eff) Unit
onResize (Context c) _ = do
    window   <- getWindow
    dims     <- nodeDimensions window

    Camera.updateOrthographic c.camera (dims.width/(-2)) 
                                       (dims.width/(2)) 
                                       (dims.height/2) 
                                       (dims.height/(-2))

    Camera.updateProjectionMatrix c.camera

    Renderer.setSize c.renderer dims.width dims.height


init :: forall eff. Eff (trace :: Trace, dom :: DOM, three :: Three | eff) Context
init = do
    window   <- getWindow
    dims     <- nodeDimensions window
    renderer <- Renderer.createWebGL {antialias: true}
    scene    <- Scene.create

    let aspect   = dims.width / dims.height
        viewsize = 1000
        
    camera   <- Camera.createOrthographic (dims.width/(-2)) 
                                          (dims.width/(2)) 
                                          (dims.height/2) 
                                          (dims.height/(-2)) 
                                          1 1000

    let ctx = context renderer scene camera

    Scene.addCamera scene camera
    Renderer.setSize renderer dims.width dims.height
    Renderer.appendToDomByID renderer "container"
    Camera.posZ camera 500

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

