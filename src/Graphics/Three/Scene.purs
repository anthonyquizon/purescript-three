module Graphics.Three.Scene where

import           Control.Monad.Eff
import           Data.Function
import qualified Graphics.Three.Camera as Cam --TODO should use import .. (Camera)
import qualified Graphics.Three.Mesh as Me -- TODO should use import .. (Mesh)
import           Graphics.Three.Util

foreign import data Scene :: *

foreign import create """
    function create() {
        return new THREE.Scene();
    }
    """ :: forall eff. Eff (three :: Three | eff) Scene

--TODO do note expose?
foreign import add """
    function add(scene) {
        return function(a) {
            return function() {
                scene.add(a);
            };
        };
    }
    """ :: forall eff a. Scene -> a -> Eff (three :: Three | eff) Unit

addCamera :: forall eff. Scene -> Cam.Camera -> Eff (three :: Three | eff) Unit
addCamera = add

addMesh :: forall eff. Scene -> Me.Mesh -> Eff (three :: Three | eff) Unit
addMesh = add

