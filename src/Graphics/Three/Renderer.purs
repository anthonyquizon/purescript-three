module Graphics.Three.Renderer where

import           Control.Monad.Eff
import           DOM
import           Data.Function
import qualified Graphics.Three.Camera as Cam
import qualified Graphics.Three.Scene as Sce
import           Graphics.Three.Types
import           Graphics.Three.Util

foreign import data Renderer :: *

foreign import createWebGL """
    function createWebGL() {
        return new THREE.WebGLRenderer();
    }
    """ :: forall eff. Eff (three :: Three | eff) Renderer

foreign import setSize """
    function setSize(renderer) {
        return function(width) {
            return function(height) {
                return function () {
                    renderer.setSize(width, height);
                };
            };
        };
    }
    """ :: forall eff. Renderer -> Number -> Number -> Eff (three :: Three | eff) Unit

foreign import render """
    function render(renderer) {
        return function(scene) {
            return function(camera) {
                return function() {
                    return renderer.render(scene, camera);
                };
            };
        };
    }
    """ :: forall eff. Renderer -> Sce.Scene -> Cam.Camera -> Eff (three :: Three | eff) Unit

foreign import domElement """
    function domElement(renderer) {
        return function() {
            return renderer.domElement;
        };
    }
    """ :: forall eff. Renderer -> Eff (three :: Three, dom :: DOM | eff) Node

foreign import appendToDomByID """
    function appendToDomByID(renderer) {
        return function rendererDomElement(idStr) {
            return function() {
                document.getElementById(idStr)
                        .appendChild(renderer.domElement);
            };
        };
    }
    """ :: forall eff. Renderer -> String -> Eff (three :: Three, dom :: DOM | eff) Unit

