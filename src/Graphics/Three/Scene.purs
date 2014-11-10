module Graphics.Three.Scene where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Util
import Graphics.Three.Camera

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

addCamera :: forall eff. Scene -> Camera -> Eff (three :: Three | eff) Unit
addCamera = add
