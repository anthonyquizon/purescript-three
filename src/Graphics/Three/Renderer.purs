module Graphics.Three.Renderer where

import           Control.Monad.Eff
import           DOM
import           Data.Function
import qualified Graphics.Three.Camera as C
import qualified Graphics.Three.Scene as S
import           Graphics.Three.Types
import           Graphics.Three.Util

foreign import data Renderer :: *

createWebGL:: forall opts. {|opts} -> ThreeEff Renderer
createWebGL = ffi ["params", ""] "new THREE.WebGLRenderer(params)"

setSize :: Renderer -> Number -> Number -> ThreeEff Unit
setSize = ffi ["renderer", "width", "height", ""] "renderer.setSize(width, height)"

render :: Renderer -> S.Scene -> C.Camera -> ThreeEff Unit
render = fpi ["renderer", "scene", "camera", ""] "renderer.render(scene, camera)"

domElement :: forall eff. Renderer -> Eff (three :: Three, dom :: DOM | eff) Node
domElement = ffi ["renderer", ""] "renderer.domElement"

appendToDomByID :: forall eff. Renderer -> String -> Eff (three :: Three, dom :: DOM | eff) Unit
appendToDomByID = fpi ["renderer", "idStr", ""] 
    "document.getElementById(idStr).appendChild(renderer.domElement)"

