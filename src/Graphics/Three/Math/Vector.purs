module Graphics.Three.Math.Vector where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Types
import Graphics.Three.Util
import Data.Function

foreign import data Vector2 :: *
foreign import data Vector3 :: *
foreign import data Vector4 :: *

foreign import createVec3Fn """
    function createVec3Fn(x, y, z) {
        return new THREE.Vector3(x, y, z);
    }
    """ :: forall eff. Fn3 Number Number Number Vector3

createVec3 :: forall eff. Number -> Number -> Number -> Vector3
createVec3 x y z = runFn3 createVec3Fn x y z

instance showVector3 :: Show Vector3 where
    show = ffi ["vector"] "'(' + vector.x + ', ' + vector.y + ', ' + vector.z + ')'"

