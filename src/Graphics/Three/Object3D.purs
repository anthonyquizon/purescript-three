module Graphics.Three.Object3D where

import Prelude (class Show, Unit, show, ($))
import Graphics.Three.Math.Vector (Vector3)
import Graphics.Three.Math.Euler (Euler)
import Graphics.Three.Types (ThreeEff)
import Graphics.Three.Util (ffi, fpi)

import Graphics.Three.Material as M
import Graphics.Three.Geometry as G

foreign import data Mesh :: Type
foreign import data Line :: Type

class Object3D a

instance object3DMesh :: Object3D Mesh
instance object3DLine :: Object3D Line

class Renderable a

instance renderableMesh :: Renderable Mesh
instance renderableLine :: Renderable Line

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

getPosition :: forall a. (Object3D a) => a -> ThreeEff Vector3 
getPosition = ffi ["object", ""] "object.position"

setPosition :: forall a. (Object3D a) => a -> Number -> Number -> Number -> ThreeEff Unit
setPosition = fpi ["object", "x", "y", "z", ""] "object.position.set(x, y, z)" --TODO change to vector?

getRotationEuler :: forall a. (Object3D a) => a -> Number -> Number -> Number -> ThreeEff Euler
getRotationEuler = ffi ["object", ""] "object.rotation"

setRotationEuler :: forall a. (Object3D a) => a -> Number -> Number -> Number -> ThreeEff Unit
setRotationEuler = fpi ["object", "x", "y", "z", ""] "object.rotation.set(x, y, z)" --TODO change to euler? Add order

rotateIncrement :: forall a. (Object3D a) => a -> Number -> Number -> Number -> ThreeEff Unit
rotateIncrement = fpi ["object", "x", "y", "z", ""] 
    "object.rotation.x += x; object.rotation.y += y; object.rotation.z += z;"

getGeometry :: forall a. (Renderable a) => a -> ThreeEff G.Geometry
getGeometry = ffi ["object", ""] "object.geometry"

getMaterial :: forall a b. Renderable a => M.Material b => a -> ThreeEff b
getMaterial = ffi ["object", ""] "object.material"

