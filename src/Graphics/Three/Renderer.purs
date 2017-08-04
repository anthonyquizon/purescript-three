module Graphics.Three.Renderer where

import           Prelude (Unit)
import           Control.Monad.Eff (Eff)
import           DOM (DOM)
import           DOM.Node.Types (Node)
import           Graphics.Three.Camera (class Camera)
import           Graphics.Three.Scene (Scene)
import           Graphics.Three.Types (Three, ThreeEff)
import           Graphics.Three.Util (fpi, ffi)

foreign import data Renderer :: Type

createWebGL:: forall opts. {|opts} -> ThreeEff Renderer
createWebGL = ffi ["params", ""] "new THREE.WebGLRenderer(params)"

setSize :: Renderer -> Number -> Number -> ThreeEff Unit
setSize = ffi ["renderer", "width", "height", ""] "renderer.setSize(width, height)"

render :: forall a. (Camera a) => Renderer -> Scene -> a -> ThreeEff Unit
render = fpi ["renderer", "scene", "camera", ""] "renderer.render(scene, camera)"

domElement :: forall eff. Renderer -> Eff (three :: Three, dom :: DOM | eff) Node
domElement = ffi ["renderer", ""] "renderer.domElement"

appendToDomByID :: forall eff. Renderer -> String -> Eff (three :: Three, dom :: DOM | eff) Unit
appendToDomByID = fpi ["renderer", "idStr", ""]
    "document.getElementById(idStr).appendChild(renderer.domElement)"
