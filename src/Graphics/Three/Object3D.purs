module Graphics.Three.Object3D where

import Graphics.Three.Math.Vector
import Graphics.Three.Types
import Graphics.Three.Util
import Control.Monad.Eff

import qualified Graphics.Three.Camera as C
import qualified Graphics.Three.Material as M
import qualified Graphics.Three.Geometry as G

foreign import data Mesh :: *
foreign import data Line :: *


class Object3D a where
    getPosition      :: a -> ThreeEff Vector3 
    setPosition      :: a -> Number -> Number -> Number -> ThreeEff Unit
    getRotationEuler :: a -> Number -> Number -> Number -> ThreeEff Euler
    setRotationEuler :: a -> Number -> Number -> Number -> ThreeEff Unit
    rotateIncrement  :: a -> Number -> Number -> Number -> ThreeEff Unit

instance object3DMesh :: Object3D Mesh where
    getPosition      = unsafeGetPosition
    setPosition      = unsafeSetPosition
    getRotationEuler = unsafeGetRotationEuler
    setRotationEuler = unsafeSetRotationEuler
    rotateIncrement  = unsafeRotateIncrement

instance object3DLine :: Object3D Line where
    getPosition      = unsafeGetPosition
    setPosition      = unsafeSetPosition
    getRotationEuler = unsafeGetRotationEuler
    setRotationEuler = unsafeSetRotationEuler
    rotateIncrement  = unsafeRotateIncrement

instance object3DCamera :: Object3D C.Camera where
    getPosition      = unsafeGetPosition
    setPosition      = unsafeSetPosition
    getRotationEuler = unsafeGetRotationEuler
    setRotationEuler = unsafeSetRotationEuler
    rotateIncrement  = unsafeRotateIncrement


class Renderable a where
    getGeometry :: a -> ThreeEff G.Geometry
    getMaterial :: forall b. (M.Material b) => a -> ThreeEff b

instance renderableMesh :: Renderable Mesh where
    getGeometry     = unsafeGetGeometry
    getMaterial     = unsafeGetMaterial

instance renderableLine :: Renderable Line where
    getGeometry     = unsafeGetGeometry
    getMaterial     = unsafeGetMaterial


data LineType = LineStrip | LinePieces

instance showLineType :: Show LineType where
    show LineStrip  = "LineStrip"
    show LinePieces = "LinePieces"


createMesh :: forall a. (M.Material a) => G.Geometry -> a -> ThreeEff Mesh
createMesh = ffi ["geometry", "material", ""] "new THREE.Mesh(geometry, material)"

createLine :: forall a. (M.Material a) => G.Geometry -> a -> LineType -> ThreeEff Line
createLine g m t = create g m $ show t
    where
        create = ffi ["geometry", "material", "lineType", ""] "new THREE.Line(geometry, material)"


unsafeGetPosition      = ffi ["object", ""] "object.position"
unsafeSetPosition      = fpi ["object", "x", "y", "z", ""] "object.position.set(x, y, z)" --TODO change to vector?
unsafeGetRotationEuler = ffi ["object", ""] "object.rotation"
unsafeSetRotationEuler = fpi ["object", "x", "y", "z", ""] "object.rotation.set(x, y, z)" --TODO change to euler? Add order
unsafeGetGeometry      = ffi ["object", ""] "object.geometry"
unsafeGetMaterial      = ffi ["object", ""] "object.material"
unsafeRotateIncrement  = fpi ["object", "x", "y", "z", ""] 
    "object.rotation.x += x; object.rotation.y += y; object.rotation.z += z;"

