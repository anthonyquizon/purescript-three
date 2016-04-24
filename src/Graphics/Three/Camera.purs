module Graphics.Three.Camera where

import Prelude (Unit)
import Graphics.Three.Types (ThreeEff)
import Graphics.Three.Util (fpi, ffi)
import Graphics.Three.Math.Vector (Vector3)
import Graphics.Three.Object3D (class Object3D)

foreign import data OrthographicCamera :: *
foreign import data PerspectiveCamera  :: *
--TODO Combined camera


data CameraType = Perspective | Orthographic

data CameraInstance = PerspectiveInstance PerspectiveCamera 
                    | OrthographicInstance OrthographicCamera


class Camera a
    

instance cameraOrthographic :: Camera OrthographicCamera
instance cameraPerspective :: Camera PerspectiveCamera

instance object3DOrthographicCamera :: Object3D OrthographicCamera
instance object3DPerspectiveCamera :: Object3D PerspectiveCamera

unproject :: forall a. (Camera a) => a -> Vector3 -> ThreeEff Vector3
unproject = ffi ["camera", "vector", ""] "vector.unproject(camera)"

updateProjectionMatrix :: forall a. (Camera a) => a -> ThreeEff Unit
updateProjectionMatrix = fpi ["camera", ""] "camera.updateProjectionMatrix()"

createOrthographic:: Number -> Number -> Number -> Number -> Number -> Number -> ThreeEff OrthographicCamera
createOrthographic = ffi ["left", "right", "top", "bottom", "near", "far", ""] 
    "new THREE.OrthographicCamera(left, right, top, bottom, near, far)"

createPerspective :: Number -> Number -> Number -> Number -> ThreeEff PerspectiveCamera
createPerspective = ffi ["fov", "aspect", "near", "far", ""]
    "new THREE.PerspectiveCamera(fov, aspect, near, far)"

getType :: forall a. (Camera a) => a -> ThreeEff CameraType
getType camera = ffi ["camera", ""] "camera.type"

setAspect :: PerspectiveCamera -> Number -> ThreeEff Unit
setAspect = fpi ["camera", "aspect", ""] "camera.aspect = aspect"

updateOrthographic :: OrthographicCamera -> Number -> Number -> Number -> Number -> ThreeEff Unit
updateOrthographic = fpi ["camera", "left", "right", "top", "bottom", ""] 
    """  camera.left   = left;
         camera.right  = right;
         camera.top    = top;
         camera.bottom = bottom;
    """


