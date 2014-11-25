module Main where

import Debug.Trace

import           Control.Monad.Eff
import           Control.Monad.Eff.Ref
import           DOM
import qualified Graphics.Three.Renderer    as Renderer
import qualified Graphics.Three.Scene       as Scene
import qualified Graphics.Three.Material    as Material
import qualified Graphics.Three.Geometry    as Geometry
import qualified Graphics.Three.Scene.Object3D.Camera      as Camera
import qualified Graphics.Three.Scene.Object3D.Mesh as Mesh
import qualified Graphics.Three.Scene.Object3D.Types as ObjectTypes
import qualified Graphics.Three.Math.Vector as Vector
import           Graphics.Three.Types     

import Examples.Common

radius   = 20.0

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

initUniforms = {
        delta: {
             "type": "v3"
            , value: Vector.createVec3 0 0 0
        },
        radius: {
             "type" : "f"
            , value : radius
        },
        drag: {
             "type" : "f"
            , value : 0.05
        }
    }

vertexShader :: String
vertexShader = """
    #ifdef GL_ES
    precision highp float;
    #endif

    uniform vec3 delta;
    uniform float radius;
    uniform float drag;

    void main() {
        vec3 pos = position;
        float p = distance(position, delta) / radius;

        vec3 temp = delta * p;
        pos += (position - temp)*0.3;

        gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
    }
"""

fragmentShader :: String 
fragmentShader = """
    #ifdef GL_ES
    precision highp float;
    #endif

    void main() {
        gl_FragColor = vec4(1.0,0.0,0.0,1.0);
    }
"""



initStateRef :: StateRef
initStateRef = stateRef 0 nPos nPos
    where
        nPos = pos 0 0

shapeMotion :: forall eff. Mesh.Mesh -> Number -> Pos -> Pos -> Eff (trace :: Trace, three :: Three | eff) Unit
shapeMotion me f (Pos p1) (Pos p2) = do
    mat <- Mesh.getMaterial me

    ObjectTypes.setPosition me p1.x p1.y 0
    Material.setUniform mat "delta" $ Vector.createVec3 dx dy 0
    
    return unit
    where
        dx = p2.x - p1.x
        dy = p2.y - p1.y


renderContext :: forall eff. RefVal StateRef -> Context -> Mesh.Mesh ->
                 Eff ( trace :: Trace, ref :: Ref, three :: Three | eff) Unit
renderContext state (Context c) me = do
    
    modifyRef state $ \(StateRef s) -> stateRef (s.frame + 1) s.pos s.prev
    s'@(StateRef s) <- readRef state

    shapeMotion me s.frame s.pos s.prev
    
    Renderer.render c.renderer c.scene c.camera


onMouseMove :: forall eff. RefVal StateRef -> Number -> Number -> Eff (ref :: Ref, trace :: Trace, dom :: DOM | eff) Unit
onMouseMove state x y = do
    modifyRef state $ \(StateRef s) -> stateRef s.frame (pos x y) s.pos
    return unit

main = do
    ctx@(Context c) <- init
    state           <- newRef initStateRef
    material        <- Material.createShader {
                            uniforms: initUniforms
                            , vertexShader:   vertexShader
                            , fragmentShader: fragmentShader
                        }
    circle          <- Geometry.createCircle radius 32 0 (2*Math.pi)
    mesh            <- Mesh.create circle material

    Scene.addMesh c.scene mesh

    mouseMove $ onMouseMove state
    doAnimation $ renderContext state ctx mesh


foreign import mouseMove """
    function mouseMove(handler) {
        return function () {
            var node = document.getElementsByTagName('canvas')[0];

            node.addEventListener('mousemove', function(e) {
                var rect = node.getBoundingClientRect(),
                    x    = (e.x - rect.left) - rect.width/2,
                    y    = - (e.y - rect.top) + rect.height/2;

                    //x =   (e.clientX / rect.width ) * 2 - 1
                    //y = - (e.clientY / rect.height ) * 2 + 1

                handler(x)(y)();
            });
        };
    }
""" :: forall eff. (Number -> Number -> Eff (dom :: DOM | eff) Unit) -> Eff (dom :: DOM | eff) Unit

