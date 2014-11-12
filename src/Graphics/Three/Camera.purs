module Graphics.Three.Camera where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Types
import Graphics.Three.Util

foreign import data Camera :: *

createOrthogonal :: forall eff. Number -> Number -> Number -> 
                       Number -> Number -> Number ->
                       Eff (three :: Three | eff) Camera
createOrthogonal = ffi ["left", "right", "top", "bottom", "near", "far", ""] 
    "new THREE.OrthographicCamera(left, right, top, bottom, near, far)"

createPerspective :: forall eff. Number -> Number -> 
                       Number -> Number -> 
                       Eff (three :: Three | eff) Camera
createPerspective = ffi ["fov", "aspect", "near", "far", ""]
    "new THREE.PerspectiveCamera(fov, aspect, near, far)"

foreign import posX """
    function posX(camera) {
        return function(x) {
            return function() {
                camera.position.x = x;
            };
        };
    }
    """ :: forall eff. Camera -> Number -> Eff (three :: Three | eff) Unit

foreign import posY """
    function posY(camera) {
        return function(y) {
            return function() {
                camera.position.y = y;
            };
        };
    }
    """ :: forall eff. Camera -> Number -> Eff (three :: Three | eff) Unit

foreign import posZ """
    function posZ(camera) {
        return function(z) {
            return function() {
                camera.position.z = z;
            };
        };
    }
    """ :: forall eff. Camera -> Number -> Eff (three :: Three | eff) Unit

