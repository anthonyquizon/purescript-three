module Graphics.Three.Scene.Object3D.Mesh where

import           Control.Monad.Eff
import           Data.Function
import qualified Graphics.Three.Geometry as Geo
import qualified Graphics.Three.Material as Mat
import           Graphics.Three.Types
import           Graphics.Three.Util
import           Graphics.Three.Scene.Object3D.Types

foreign import data Mesh :: *

instance meshObject3D :: Object3D Mesh where
    getPosition = ffi ["object", ""] "object.position"
    setPosition = fpi ["object", "x", "y", "z", ""] "object.position.set(x, y, z)"

create :: forall eff. Geo.Geometry -> Mat.Material -> Eff (three :: Three | eff) Mesh
create = ffi ["geometry", "material", ""] "new THREE.Mesh(geometry, material);"

rotateIncrement :: forall eff. Mesh -> Number -> Number -> Number -> Eff (three :: Three | eff) Unit
rotateIncrement = ffi ["mesh", "x", "y", "z"]
    """ function () {
            mesh.rotation.x += x;
            mesh.rotation.y += y;
            mesh.rotation.z += z;
        }
    """

getGeometry :: forall eff. Mesh -> Eff (three :: Three | eff) Geo.Geometry
getGeometry = ffi ["mesh", ""] "mesh.geometry"

getMaterial :: forall eff. Mesh -> Eff (three :: Three | eff) Mat.Material
getMaterial = ffi ["mesh", ""] "mesh.material"
