module Graphics.Three.Renderer where

import           Prelude (Unit)
import           Effect (Effect)
import           Web.DOM.Node (Node)
import           Graphics.Three.Camera (class Camera)
import           Graphics.Three.Scene (Scene)
import           Graphics.Three.Util (fpi, ffi)

foreign import data Renderer :: Type

createWebGL:: forall opts. {|opts} -> Effect Renderer
createWebGL = ffi ["params", ""] "new THREE.WebGLRenderer(params)"

setSize :: Renderer -> Number -> Number -> Effect Unit
setSize = ffi ["renderer", "width", "height", ""] "renderer.setSize(width, height)"

render :: forall a. Camera a => Renderer -> Scene -> a -> Effect Unit
render = fpi ["renderer", "scene", "camera", ""] "renderer.render(scene, camera)"

domElement :: Renderer -> Effect Node
domElement = ffi ["renderer", ""] "renderer.domElement"

appendToDomByID :: Renderer -> String -> Effect Unit
appendToDomByID = fpi ["renderer", "idStr", ""]
    "document.getElementById(idStr).appendChild(renderer.domElement)"
