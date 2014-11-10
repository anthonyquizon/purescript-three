module Graphics.Three.Mesh where

import           Control.Monad.Eff
import           Data.Function
import qualified Graphics.Three.Geometry as Geo
import qualified Graphics.Three.Material as Mat
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

