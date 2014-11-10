module Graphics.Three.Camera where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Util

foreign import data Camera :: *

foreign import createOrthogonal """
    function createOrthogonal(left) {
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

foreign import createPerspective """
    function createPerspective(fov) {
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

