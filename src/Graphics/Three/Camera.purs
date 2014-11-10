module Graphics.Three.Camera where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Util

foreign import data Camera :: *

foreign import createCamera """
    function createCamera(left, right, top, bottom, near, far) {
        new THREE.OrthographicCamera(left, right, top, bottom, near, far);
    }
    """ :: forall eff. Fn6 Number Number Number 
                           Number Number Number 
                           (Eff (three :: Three | eff) Camera)

foreign import cameraPosX """
    function cameraPos(camera, x) {
        camera.position.x = x;
    }
    """ :: forall eff. Fn2 Camera Number (Eff (three :: Three | eff) Unit)

foreign import cameraPosY """
    function cameraPos(camera, y) {
        camera.position.y = y;
    }
    """ :: forall eff. Fn2 Camera Number (Eff (three :: Three | eff) Unit)


foreign import cameraPosZ """
    function cameraPos(camera, z) {
        camera.position.z = z;
    }
    """ :: forall eff. Fn2 Camera Number (Eff (three :: Three | eff) Unit)

