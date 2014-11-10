module Graphics.Three.Camera where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Util

foreign import data Camera :: *

foreign import createOrthogonalCamera """
    function createOrthogonalCamera(left) {
        return function(right) {
            return function(top) {
                return function(bottom) {
                    return function(near) {
                        return function(far) {
                            return function() {
                                return new THREE.OrthographicCamera(left, right, top, bottom, near, far);
                            };
                        };
                    };
                };
            };
        };
    }
    """ :: forall eff. Number -> Number -> Number -> 
                       Number -> Number -> Number ->
                       Eff (three :: Three | eff) Camera

foreign import createPerspectiveCamera """
    function createPerspectiveCamera(fov) {
        return function(aspect) {
            return function(near) {
                return function(far) {
                    return function() {
                        return new THREE.PerspectiveCamera(fov, aspect, near, far);
                    };
                };
            };
        };
    }
    """ :: forall eff. Number -> Number -> 
                       Number -> Number -> 
                       Eff (three :: Three | eff) Camera

foreign import cameraPosX """
    function cameraPosX(camera) {
        return function(x) {
            camera.position.x = x;
        };
    }
    """ :: forall eff. Camera -> Number -> Eff (three :: Three | eff) Unit

foreign import cameraPosY """
    function cameraPosY(camera) {
        return function(y) {
            camera.position.y = y;
        };
    }
    """ :: forall eff. Camera -> Number -> Eff (three :: Three | eff) Unit

foreign import cameraPosZ """
    function cameraPosZ(camera) {
        return function(z) {
            camera.position.z = z;
        };
    }
    """ :: forall eff. Camera -> Number -> Eff (three :: Three | eff) Unit


