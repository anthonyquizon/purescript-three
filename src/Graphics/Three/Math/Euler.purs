module Graphics.Three.Math.Euler where

import Prelude (class Show)
import Graphics.Three.Util (ffi)

foreign import data Euler :: Type

--TODO order

foreign import create :: Number -> Number -> Number -> Euler

instance showEuler :: Show Euler where
    show = ffi ["euler"] "'(' + euler.x + ', ' + euler.y + ', ' + euler.z + ')'"


