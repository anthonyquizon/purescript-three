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
    getPosition :: a -> ThreeEff Vector3 
    setPosition :: a -> Number -> Number -> Number -> ThreeEff Unit
    getGeometry :: a -> ThreeEff G.Geometry
    getMaterial :: a -> ThreeEff M.Material
    {--getRotationEuler :: forall eff. a -> Number -> Number -> Number -> Eff (three :: Three | eff) --}
    {--setRotationEuler :: forall eff. a -> Number -> Number -> Number -> Eff (three :: Three | eff) Unit--}
    rotateIncrement :: a -> Number -> Number -> Number -> ThreeEff Unit

instance object3DMesh :: Object3D Mesh where
    getPosition     = unsafeGetPosition
    setPosition     = unsafeSetPosition
    getGeometry     = unsafeGetGeometry
    getMaterial     = unsafeGetMaterial
    rotateIncrement = unsafeRotateIncrement

instance object3DLine :: Object3D Line where
    getPosition     = unsafeGetPosition
    setPosition     = unsafeSetPosition
    getGeometry     = unsafeGetGeometry
    getMaterial     = unsafeGetMaterial
    rotateIncrement = unsafeRotateIncrement

instance object3DCamera :: Object3D C.Camera where
    getPosition     = unsafeGetPosition
    setPosition     = unsafeSetPosition
    getGeometry     = unsafeGetGeometry
    getMaterial     = unsafeGetMaterial
    rotateIncrement = unsafeRotateIncrement


data LineType = LineStrip | LinePiece

instance showLineType :: Show LineType where
    show LineStrip = "LineStrip"
    show LinePiece = "LinePiece"

createMesh :: G.Geometry -> M.Material -> ThreeEff Mesh
createMesh = ffi ["geometry", "material", ""] "new THREE.Mesh(geometry, material)"

createLine :: G.Geometry -> M.Material -> LineType -> ThreeEff Line
createLine g m t = create g m $ show t
    where
        create = ffi ["geometry", "material", "lineType", ""] "new THREE.Line(geometry, material)"


unsafeGetPosition = ffi ["object", ""] "object.position"
unsafeSetPosition = fpi ["object", "x", "y", "z", ""] "object.position.set(x, y, z)"
unsafeGetGeometry = ffi ["object", ""] "object.geometry"
unsafeGetMaterial = ffi ["object", ""] "object.material"
unsafeRotateIncrement = fpi ["object", "x", "y", "z", ""] 
    "object.rotation.x += x; object.rotation.y += y; object.rotation.z += z;"

