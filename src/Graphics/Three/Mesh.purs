module Graphics.Three.Mesh where

import           Control.Monad.Eff
import           Data.Function
import qualified Graphics.Three.Geometry as Geo
import qualified Graphics.Three.Material as Mat
import           Graphics.Three.Types
import           Graphics.Three.Util

foreign import data Mesh :: *

foreign import create """
    function create (geometry) {
        return function(material) {
            return function() {
                return new THREE.Mesh(geometry, material);
            };
        };
    }
    """ :: forall eff. Geo.Geometry -> Mat.Material -> Eff (three :: Three | eff) Mesh

rotateIncrement :: forall eff. Mesh -> Number -> Number -> Number -> Eff (three :: Three | eff) Unit
rotateIncrement = ffi ["mesh", "x", "y", "z"]
    """ function () {
            mesh.rotation.x += x;
            mesh.rotation.y += y;
            mesh.rotation.z += z;
        }
    """
