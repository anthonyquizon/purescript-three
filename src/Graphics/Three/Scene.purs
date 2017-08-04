module Graphics.Three.Scene where

import Prelude (Unit)
import Graphics.Three.Object3D (class Object3D)
import Graphics.Three.Types (ThreeEff)
import Graphics.Three.Util (fpi, ffi)

foreign import data Scene :: Type

create :: ThreeEff Scene
create = ffi [""] "new THREE.Scene()"

addObject :: forall a. (Object3D a) => Scene -> a -> ThreeEff Unit
addObject = fpi ["scene", "a", ""] "scene.add(a)"

