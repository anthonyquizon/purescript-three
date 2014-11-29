module Graphics.Three.Scene.Camera where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Types
import Graphics.Three.Util
import Graphics.Three.Math.Vector
import           Graphics.Three.Scene.Object3D

foreign import data Camera :: *

createOrthographic:: forall eff. Number -> Number -> Number -> 
                       Number -> Number -> Number ->
                       Eff (three :: Three | eff) Camera
createOrthographic = ffi ["left", "right", "top", "bottom", "near", "far", ""] 
    "new THREE.OrthographicCamera(left, right, top, bottom, near, far)"

createPerspective :: forall eff. Number -> Number -> 
                       Number -> Number -> 
                       Eff (three :: Three | eff) Camera
createPerspective = ffi ["fov", "aspect", "near", "far", ""]
    "new THREE.PerspectiveCamera(fov, aspect, near, far)"


setAspect :: forall eff. Camera -> Number -> Eff (three :: Three | eff) Unit
setAspect = fpi ["camera", "aspect", ""] "camera.aspect = aspect"


updateOrthographic :: forall eff. Camera -> 
                      Number -> Number -> Number -> Number ->
                      Eff (three :: Three | eff) Unit
updateOrthographic = fpi ["camera", "left", "right", "top", "bottom", ""] 
    """  camera.left   = left;
         camera.right  = right;
         camera.top    = top;
         camera.bottom = bottom;
    """

unproject :: forall eff. Camera -> Vector3 -> Eff (three :: Three | eff) Vector3
unproject = ffi ["camera", "vector", ""] "vector.unproject(camera)"

updateProjectionMatrix :: forall eff. Camera -> Eff (three :: Three | eff) Unit
updateProjectionMatrix = fpi ["camera", ""] "camera.updateProjectionMatrix()"

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

