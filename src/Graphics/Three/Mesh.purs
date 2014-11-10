module Graphics.Three.Mesh where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Geometry
import Graphics.Three.Material
import Graphics.Three.Util

foreign import data Mesh :: *

foreign import createMesh """
    function createMesh (geometry) {
        return function(material) {
            return function() {
                return new THREE.Mesh(geometry, material);
            };
        };
    }
    """ :: forall eff. Geometry -> Material -> Eff (three :: Three | eff) Mesh

