module Graphics.Three.Scene where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Util
import Graphics.Three.Camera

foreign import data Scene :: *

foreign import createScene """
    function createScene() {
        return new THREE.Scene();
    }
    """ :: forall eff. Eff (three :: Three | eff) Scene

--TODO do note expose?
foreign import sceneAdd """
    function sceneAdd(scene) {
        return function(a) {
            scene.add(a);
        }
    }
    """ :: forall eff a. Scene -> a -> Eff (three :: Three | eff) Unit

addCamera :: forall eff. Scene -> Camera -> Eff (three :: Three | eff) Unit
addCamera = sceneAdd


