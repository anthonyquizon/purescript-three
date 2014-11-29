module Main where

import Debug.Trace

import           Control.Monad.Eff
import           Control.Monad.Eff.Ref
import           DOM
import qualified Graphics.Three.Renderer    as Renderer
import qualified Graphics.Three.Scene       as Scene
import qualified Graphics.Three.Material    as Material
import qualified Graphics.Three.Geometry    as Geometry
import qualified Graphics.Three.Camera      as Camera
import qualified Graphics.Three.Object3D    as Object3D
import qualified Graphics.Three.Math.Vector as Vector
import           Graphics.Three.Types     

import Examples.Common

radius = 40.0


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
            , value : 0.33
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
        pos += (position - temp) * drag;

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




shapeMotion :: forall eff. Object3D.Mesh -> Number -> Pos -> Pos -> Eff (trace :: Trace, three :: Three | eff) Unit
shapeMotion me f (Pos p1) (Pos p2) = do
    mat <- Object3D.getMaterial me

    Object3D.setPosition me p1.x p1.y 0
    Material.setUniform mat "delta" $ Vector.createVec3 dx dy 0
    
    return unit
    where
        dx = p2.x - p1.x
        dy = p2.y - p1.y

renderContext :: forall eff. RefVal StateRef -> Context -> Object3D.Mesh ->
                 Eff ( trace :: Trace, ref :: Ref, three :: Three | eff) Unit
renderContext state (Context c) me = do
    
    modifyRef state $ \(StateRef s) -> stateRef (s.frame + 1) s.pos s.prev
    s'@(StateRef s) <- readRef state

    shapeMotion me s.frame s.pos s.prev
    
    Renderer.render c.renderer c.scene c.camera


onMouseMove :: forall eff. Context -> RefVal StateRef -> Event -> Eff (three :: Three, ref :: Ref, trace :: Trace, dom :: DOM | eff) Unit
onMouseMove (Context c) state e = do
    canvas <- getElementsByTagName "canvas"
    dims   <- nodeDimensions canvas

    let x =  e.x - (dims.width/2)
        y = -e.y + (dims.height/2)

    modifyRef state $ \(StateRef s) -> 
        stateRef s.frame (pos x y) s.pos

    return unit

main = do
    ctx@(Context c) <- initContext
    state           <- newRef initStateRef
    material        <- Material.createShader {
                            uniforms: initUniforms
                            , vertexShader:   vertexShader
                            , fragmentShader: fragmentShader
                        }
    circle          <- Geometry.createCircle radius 32 0 (2*Math.pi)
    mesh            <- Object3D.createMesh circle material

    Scene.add c.scene mesh

    canvas <- getElementsByTagName "canvas"
    addEventListener canvas "mousemove" $ onMouseMove ctx state

    doAnimation $ renderContext state ctx mesh

