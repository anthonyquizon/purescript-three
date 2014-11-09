module Graphics.Three where

import Control.Monad.Eff
import Data.Function


foreign import data Three :: !
foreign import data Scene :: *
foreign import data Renderer :: *
foreign import data Camera :: *


foreign import createScene """
    function () {
        return new THREE.Scene();
    }
    """ :: forall eff. Eff (three :: Three) Scene

foreign import createWebGLRenderer """
    function () {
        return new THREE.WebGLRenderer();
    }
    """ :: forall eff. Eff (three :: Three) Renderer

foreign import createCamera """
    function (left, right, top, bottom, near, far) {
        new THREE.OrthographicCamera(left, right, top, bottom, near, far);
    }
    """ :: forall eff. Fn6 Number Number Number 
                           Number Number Number 
                           (Eff (three :: Three) Camera)



