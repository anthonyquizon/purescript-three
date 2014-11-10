module Graphics.Three.Renderer where

import Control.Monad.Eff
import DOM
import Data.Function
import Graphics.Three.Util

foreign import data Renderer :: *

foreign import createWebGLRenderer """
    function createWebGLRenderer() {
        return new THREE.WebGLRenderer();
    }
    """ :: forall eff. Eff (three :: Three | eff) Renderer

foreign import rendererSetSize """
    function rendererSetSize(renderer, width, height) {
        renderer.setSize(width, height);
    }
    """ :: forall eff. Fn3 Renderer Number Number (Eff (three :: Three | eff) Unit)

foreign import rendererDomElement """
    function rendererDomElement(renderer) {
        return function() {
            return renderer.domElement();
        };
    }
    """ :: forall eff. Renderer -> Eff (three :: Three, dom :: DOM | eff) Node


