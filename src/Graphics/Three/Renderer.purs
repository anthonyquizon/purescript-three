module Graphics.Three.Renderer where

import           Control.Monad.Eff
import           DOM
import           Data.Function
import qualified Graphics.Three.Scene.Object3D.Camera as Cam
import qualified Graphics.Three.Scene as Sce
import           Graphics.Three.Types
import           Graphics.Three.Util

foreign import data Renderer :: *

createWebGL:: forall eff opts. {|opts} -> Eff (three :: Three | eff) Renderer
createWebGL = ffi ["params", ""] "new THREE.WebGLRenderer(params)"

setSize :: forall eff. Renderer -> Number -> Number -> Eff (three :: Three | eff) Unit
setSize = ffi ["renderer", "width", "height", ""] "renderer.setSize(width, height)"

render :: forall eff. Renderer -> Sce.Scene -> Cam.Camera -> Eff (three :: Three | eff) Unit
render = fpi ["renderer", "scene", "camera", ""] "renderer.render(scene, camera)"

domElement :: forall eff. Renderer -> Eff (three :: Three, dom :: DOM | eff) Node
domElement = ffi ["renderer", ""] "renderer.domElement"

appendToDomByID :: forall eff. Renderer -> String -> Eff (three :: Three, dom :: DOM | eff) Unit
appendToDomByID = fpi ["renderer", "idStr", ""] 
    """ document.getElementById(idStr)
                .appendChild(renderer.domElement);
    """

