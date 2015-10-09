module Graphics.Three.Math.Euler where

import Prelude
import Control.Monad.Eff
import Data.Function
import Graphics.Three.Types
import Graphics.Three.Util
import Data.Function

foreign import data Euler :: *

--TODO order

foreign import createEulerFn :: forall eff. Fn3 Number Number Number Euler

create :: forall eff. Number -> Number -> Number -> Euler
create x y z = runFn3 createEulerFn x y z


instance showEuler :: Show Euler where
    show = ffi ["euler"] "'(' + euler.x + ', ' + euler.y + ', ' + euler.z + ')'"


