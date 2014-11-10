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
    function rendererSetSize(renderer) {
        return function(width) {
            return function(height) {
                return function () {
                    renderer.setSize(width, height);
                };
            };
        };
    }
    """ :: forall eff. Renderer -> Number -> Number -> Eff (three :: Three | eff) Unit

foreign import rendererDomElement """
    function rendererDomElement(renderer) {
        return function() {
            return renderer.domElement;
        };
    }
    """ :: forall eff. Renderer -> Eff (three :: Three, dom :: DOM | eff) Node

foreign import appendRendererByID """
    function appendRendererByID(renderer) {
        return function rendererDomElement(idStr) {
            return function() {
                document.getElementById(idStr)
                        .appendChild(renderer.domElement);
            };
        };
    }
    """ :: forall eff. Renderer -> String -> Eff (three :: Three, dom :: DOM | eff) Unit
