module Graphics.Three.Math.Vector where

import Prelude (class Show)
import Graphics.Three.Util (ffi)

foreign import data Vector2 :: *
foreign import data Vector3 :: *
foreign import data Vector4 :: *

-- TODO class Vector properties
    -- vector.x
    -- ...

foreign import createVec3 :: Number -> Number -> Number -> Vector3

--TODO instance

getX :: Vector3 -> Number
getX = ffi ["vector", ""] "vector.x"

getY :: Vector3 -> Number
getY = ffi ["vector", ""] "vector.y"

getZ :: Vector3 -> Number
getZ = ffi ["vector", ""] "vector.z"


instance showVector3 :: Show Vector3 where
    show = ffi ["vector"] "'(' + vector.x + ', ' + vector.y + ', ' + vector.z + ')'"

