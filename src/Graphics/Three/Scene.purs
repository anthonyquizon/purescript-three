module Graphics.Three.Scene where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Util

foreign import data Scene :: *

foreign import createScene """
    function () {
        return new THREE.Scene();
    }
    """ :: forall eff. Eff (three :: Three) Scene
