module Graphics.Three.Math.Euler where

import Prelude
import Control.Monad.Eff
import Data.Function
import Graphics.Three.Types
import Graphics.Three.Util
import Data.Function

foreign import data Euler :: *

--TODO order

foreign import create :: forall eff. Number -> Number -> Number -> Euler

instance showEuler :: Show Euler where
    show = ffi ["euler"] "'(' + euler.x + ', ' + euler.y + ', ' + euler.z + ')'"


