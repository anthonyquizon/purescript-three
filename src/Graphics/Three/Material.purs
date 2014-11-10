module Graphics.Three.Material where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Util

foreign import data Material :: *

--TODO material properties
foreign import createMeshBasicMaterial """
    function createMeshBasicMaterial () {
        return new THREE.Mesh(geometry, material);
    }
    """ :: forall eff. Eff (three :: Three | eff) Material

