module Graphics.Three.Math.Vector where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Types
import Graphics.Three.Util
import Data.Function

foreign import data Vector3 :: *

foreign import createFn """
    function createFn(x, y, z) {
        return new THREE.Vector3(1, 0, 0);
    }
    """ :: forall eff. Fn3 Number Number Number (Eff (three :: Three | eff) Vector3)

create :: forall eff. Number -> Number -> Number -> (Eff (three :: Three | eff) Vector3)
create x y z = runFn3 createFn x y z


