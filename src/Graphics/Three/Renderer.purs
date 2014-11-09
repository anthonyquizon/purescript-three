module Graphics.Three.Renderer where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Util

foreign import data Renderer :: *

foreign import createWebGLRenderer """
    function () {
        return new THREE.WebGLRenderer();
    }
    """ :: forall eff. Eff (three :: Three) Renderer


