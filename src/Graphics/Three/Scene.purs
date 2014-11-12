module Graphics.Three.Scene where

import           Control.Monad.Eff
import           Data.Function
import qualified Graphics.Three.Camera as Cam --TODO should use import .. (Camera)
import qualified Graphics.Three.Mesh as Me -- TODO should use import .. (Mesh)
import           Graphics.Three.Types
import           Graphics.Three.Util

foreign import data Scene :: *

create :: forall eff. Eff (three :: Three | eff) Scene
create = ffi [""] "new THREE.Scene()"

add :: forall eff a. Scene -> a -> Eff (three :: Three | eff) Unit
add = fpi ["scene", "a", ""] "scene.add(a)"

addCamera :: forall eff. Scene -> Cam.Camera -> Eff (three :: Three | eff) Unit
addCamera = add

addMesh :: forall eff. Scene -> Me.Mesh -> Eff (three :: Three | eff) Unit
addMesh = add

