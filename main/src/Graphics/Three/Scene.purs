module Graphics.Three.Scene where

import Prelude
import Control.Monad.Eff
import Data.Function
import Graphics.Three.Object3D
import Graphics.Three.Types
import Graphics.Three.Util

foreign import data Scene :: *

create :: ThreeEff Scene
create = ffi [""] "new THREE.Scene()"

addObject :: forall a. (Object3D a) => Scene -> a -> ThreeEff Unit
addObject = fpi ["scene", "a", ""] "scene.add(a)"

