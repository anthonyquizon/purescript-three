module Graphics.Three.Math.Vector where

import Prelude
import Control.Monad.Eff
import Data.Function
import Graphics.Three.Types
import Graphics.Three.Util
import Data.Function

foreign import data Vector2 :: *
foreign import data Vector3 :: *
foreign import data Vector4 :: *

-- TODO class Vector properties
    -- vector.x
    -- ...

foreign import createVec3Fn :: forall eff. Fn3 Number Number Number Vector3

createVec3 :: forall eff. Number -> Number -> Number -> Vector3
createVec3 x y z = runFn3 createVec3Fn x y z



--TODO instance

getX :: Vector3 -> Number
getX = ffi ["vector", ""] "vector.x"

getY :: Vector3 -> Number
getY = ffi ["vector", ""] "vector.y"

getZ :: Vector3 -> Number
getZ = ffi ["vector", ""] "vector.z"


instance showVector3 :: Show Vector3 where
    show = ffi ["vector"] "'(' + vector.x + ', ' + vector.y + ', ' + vector.z + ')'"

