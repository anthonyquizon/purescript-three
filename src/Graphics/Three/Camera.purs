module Graphics.Three.Camera where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Util

foreign import data Camera :: *

foreign import createCamera """
    function (left, right, top, bottom, near, far) {
        new THREE.OrthographicCamera(left, right, top, bottom, near, far);
    }
    """ :: forall eff. Fn6 Number Number Number 
                           Number Number Number 
                           (Eff (three :: Three) Camera)



