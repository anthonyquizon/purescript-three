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

newtype Pos = Pos {
          x :: Number
        , y :: Number
    }

pos :: Number -> Number -> Pos
pos x y = Pos {
          x: x
        , y: y
    }

instance showPos :: Show Pos where
    show (Pos p) = 
        "x: " ++ show p.x ++ ", y: " ++ show p.y

newtype StateRef = StateRef {
          frame :: Number
        , pos   :: Pos
        , prev  :: Pos
    }

instance showStateRef :: Show StateRef where
    show (StateRef s) = 
        "frame: " ++ show s.frame ++ "\n" ++
        "pos: "   ++ show s.pos   ++ "\n" ++
        "prev: "  ++ show s.prev  ++ "\n"

stateRef :: Number -> Pos -> Pos -> StateRef
stateRef f p pv = StateRef {
          frame: f
        , pos: p
        , prev: pv
    }


initStateRef :: StateRef
initStateRef = stateRef 0 nPos nPos
    where
        nPos = pos 0 0

doAnimation :: forall eff. Eff (three :: Three | eff) Unit -> Eff (three :: Three | eff) Unit
doAnimation animate = do
    animate
    requestAnimationFrame $ doAnimation animate


renderContext :: forall a eff. RefVal StateRef -> 
                 Eff ( trace :: Trace, ref :: Ref, three :: Three | eff) Unit
renderContext state = do
    
    modifyRef state $ \(StateRef s) -> stateRef (s.frame + 1) s.pos s.prev
    s'@(StateRef s) <- readRef state
    
    print s'
    return unit
    {--Renderer.render c.renderer c.scene c.camera--}


onMouseMove :: forall eff. RefVal StateRef -> Number -> Number -> Eff (ref :: Ref, trace :: Trace, dom :: DOM | eff) Unit
onMouseMove state x y = do
    modifyRef state $ \(StateRef s) -> stateRef s.frame s.prev (pos x y)
    return unit

main = do
    state    <- newRef initStateRef
    renderer <- Renderer.createWebGL {antialias: true}

    Renderer.setSize renderer width height
    Renderer.appendToDomByID renderer "container"

    mouseMove $ onMouseMove state
    doAnimation $ renderContext state


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

