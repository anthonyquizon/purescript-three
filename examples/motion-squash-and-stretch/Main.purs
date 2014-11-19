module Main where

import Debug.Trace

import           Control.Monad.Eff
import           Control.Monad.Eff.Ref
import           DOM
import qualified Graphics.Three.Renderer as Renderer
import qualified Graphics.Three.Scene    as Scene
import qualified Graphics.Three.Camera   as Camera
import qualified Graphics.Three.Material as Material
import qualified Graphics.Three.Geometry as Geometry
import qualified Graphics.Three.Mesh     as Mesh
import           Graphics.Three.Types     

width    = 500
height   = 500


doAnimation :: forall eff. Eff (three :: Three | eff) Unit -> Eff (three :: Three | eff) Unit
doAnimation animate = do
    animate
    requestAnimationFrame $ doAnimation animate

-- callback 
-- on mouse move

onMouseMove :: forall eff. Number -> Number -> Eff (trace :: Trace, dom :: DOM | eff) Unit
onMouseMove x y = do
    print x
    print y
    return unit


main = do
    frame    <- newRef 0
    renderer <- Renderer.createWebGL {antialias: true}

    Renderer.setSize renderer width height
    Renderer.appendToDomByID renderer "container"

    mouseMove onMouseMove


foreign import mouseMove """
    function mouseMove(handler) {
        return function () {
            var node = document.getElementsByTagName('canvas')[0];

            node.addEventListener('mousemove', function(e) {
                var rect = node.getBoundingClientRect(),
                    x    = e.x - rect.left,
                    y    = e.y - rect.top;

                handler(x)(y)();
            });
        };
    }
""" :: forall eff. (Number -> Number -> Eff (dom :: DOM | eff) Unit) -> Eff (dom :: DOM | eff) Unit

foreign import requestAnimationFrame """
    function requestAnimationFrame(callback) {
        return function() {
            return window.requestAnimationFrame(callback);
        }
    }
    """ :: forall eff. Eff eff Unit -> Eff eff Unit

