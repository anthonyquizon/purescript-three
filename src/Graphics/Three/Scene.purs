module Graphics.Three.Scene where

import Prelude (Unit)
import Effect (Effect)
import Graphics.Three.Object3D (class Object3D)
import Graphics.Three.Util (fpi, ffi)

foreign import data Scene :: Type

create :: Effect Scene
create = ffi [""] "new THREE.Scene()"

addObject :: forall a. Object3D a => Scene -> a -> Effect Unit
addObject = fpi ["scene", "a", ""] "scene.add(a)"

