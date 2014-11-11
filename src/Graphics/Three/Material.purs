module Graphics.Three.Material where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Types
import Graphics.Three.Util

foreign import data Material :: *


--TODO material properties
foreign import create """
    function create() {
        return new THREE.Material();
    }
    """ :: forall eff. Eff (three :: Three | eff) Material

--TODO material properties
foreign import createMeshBasic """
    function createMeshBasic() {
        return new THREE.MeshBasicMaterial();
    }
    """ :: forall eff. Eff (three :: Three | eff) Material

