module Graphics.Three.Camera where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Types
import Graphics.Three.Util
import Graphics.Three.Math.Vector

foreign import data Camera :: *

data CameraType = CameraOrthographic | CameraPerspective

createOrthographic:: Number -> Number -> Number -> Number -> Number -> Number -> ThreeEff Camera
createOrthographic = ffi ["left", "right", "top", "bottom", "near", "far", ""] 
    "new THREE.OrthographicCamera(left, right, top, bottom, near, far)"

createPerspective :: Number -> Number -> Number -> Number -> ThreeEff Camera
createPerspective = ffi ["fov", "aspect", "near", "far", ""]
    "new THREE.PerspectiveCamera(fov, aspect, near, far)"


setAspect :: Camera -> Number -> ThreeEff Unit
setAspect = fpi ["camera", "aspect", ""] "camera.aspect = aspect"


updateOrthographic :: Camera -> Number -> Number -> Number -> Number -> ThreeEff Unit
updateOrthographic = fpi ["camera", "left", "right", "top", "bottom", ""] 
    """  camera.left   = left;
         camera.right  = right;
         camera.top    = top;
         camera.bottom = bottom;
    """

unproject :: Camera -> Vector3 -> ThreeEff Vector3
unproject = ffi ["camera", "vector", ""] "vector.unproject(camera)"

updateProjectionMatrix :: Camera -> ThreeEff Unit
updateProjectionMatrix = fpi ["camera", ""] "camera.updateProjectionMatrix()"

