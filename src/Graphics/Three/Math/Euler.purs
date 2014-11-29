module Graphics.Three.Math.Euler where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Types
import Graphics.Three.Util
import Data.Function

foreign import data Euler :: *

--TODO order

foreign import createEulerFn """
    function createEulerFn(x, y, z) {
        return new THREE.Euler(x, y, z);
    }
    """ :: forall eff. Fn3 Number Number Number Euler

create :: forall eff. Number -> Number -> Number -> Euler
create x y z = runFn3 createEulerFn x y z


instance showEuler :: Show Euler where
    show = ffi ["euler"] "'(' + euler.x + ', ' + euler.y + ', ' + euler.z + ')'"


