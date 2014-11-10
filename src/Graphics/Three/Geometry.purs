module Graphics.Three.Geometry where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Material
import Graphics.Three.Util

foreign import data Geometry :: *


foreign import createBox """
    function createBox(x) {
        return function(y) {
            return function(z) {
                return function() {
                    return new THREE.BoxGeometry(x, y, z);
                }
            }
        }
    }
    """ :: forall eff. Number -> Number -> Number -> Eff (three :: Three | eff) Geometry

