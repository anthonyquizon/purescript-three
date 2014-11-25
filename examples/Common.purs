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

type WindowDims = {
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

onResize :: forall eff. Context -> Eff (three :: Three | eff) Unit
onResize (Context c) = do
    win <- windowDimensions

--    windowHalfX = window.innerWidth / 2;
--    windowHalfY = window.innerHeight / 2;
    Camera.setAspect c.camera $ win.width / win.height
    Camera.updateProjectionMatrix c.camera

    Renderer.setSize c.renderer win.width win.height


init :: forall eff. Eff (trace :: Trace, dom :: DOM, three :: Three | eff) Context
init = do
    win      <- windowDimensions
    renderer <- Renderer.createWebGL {antialias: true}
    scene    <- Scene.create
    camera   <- Camera.createPerspective 45 (win.width/win.height) 1 1000

    let ctx = context renderer scene camera

    Scene.addCamera scene camera
    Renderer.setSize renderer win.width win.height
    Renderer.appendToDomByID renderer "container"
    Camera.posZ camera 500

    print win.width
    print win.height

    addEventListener "resize" $ onResize ctx
    return ctx
    

windowDimensions :: forall eff. Eff eff WindowDims
windowDimensions = ffi [""] "{ width: window.innerWidth, height: window.innerHeight }"

addEventListener :: forall eff. String -> Eff eff Unit -> Eff eff Unit
addEventListener = fpi ["name","callback", ""] "window.addEventListener(name, callback)"

requestAnimationFrame :: forall eff. Eff eff Unit -> Eff eff Unit
requestAnimationFrame = fpi ["callback", ""] "window.requestAnimationFrame(callback)"

