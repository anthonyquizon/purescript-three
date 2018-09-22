module Examples.MotionStretch where

import Prelude (Unit, bind, discard, negate, pure, unit, ($), (*), (+), (-), (/))
import Effect (Effect)
import Effect.Ref as Ref
import Graphics.Three.Scene       as Scene
import Graphics.Three.Material    as Material
import Graphics.Three.Geometry    as Geometry
import Graphics.Three.Camera      as Camera
import Graphics.Three.Object3D    as Object3D
import Graphics.Three.Math.Vector as Vector
import Math (pi)

import Examples.Common

radius = 40.0

initUniforms ::  { delta :: { "type" :: String, value :: Vector.Vector3 }
                 , radius :: { "type" :: String, value :: Number }
                 , drag :: { "type" :: String, value :: Number }
                 }
initUniforms = {
        delta: {
             "type": "v3"
            , value: Vector.createVec3 0.0 0.0 0.0
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

shapeMotion :: Object3D.Mesh -> Number -> Pos -> Pos -> Effect Unit
shapeMotion me f (Pos p1) (Pos p2) = do
    mat <- Object3D.getMaterial me

    Object3D.setPosition me p1.x p1.y 0.0
    Material.setUniform mat "delta" $ Vector.createVec3 dx dy 0.0
    
    pure unit
    where
        dx = p2.x - p1.x
        dy = p2.y - p1.y

render :: Ref.Ref StateRef -> Context -> Object3D.Mesh -> Effect Unit
render state context me = do
    
    Ref.modify_ (\(StateRef s) -> stateRef (s.frame + 1.0) s.pos s.prev) state
    s'@(StateRef s) <- Ref.read state

    shapeMotion me s.frame s.pos s.prev
    
    renderContext context


onMouseMove :: Context -> Ref.Ref StateRef -> Event -> Effect Unit
onMouseMove (Context c) state e = do
    canvas <- getElementsByTagName "canvas"
    dims   <- nodeDimensions canvas

    let x =  e.x - (dims.width / 2.0)
        y = -e.y + (dims.height / 2.0)

    Ref.modify_ (\(StateRef s) -> stateRef s.frame (pos x y) s.pos) state

    pure unit

main :: Effect Unit
main = do
    ctx@(Context c) <- initContext Camera.Orthographic
    state           <- Ref.new initStateRef
    material        <- Material.createShader {
                            uniforms: initUniforms
                            , vertexShader:   vertexShader
                            , fragmentShader: fragmentShader
                        }
    circle          <- Geometry.createCircle radius 32.0 0.0 (2.0 * pi)
    mesh            <- Object3D.createMesh circle material

    Scene.addObject c.scene mesh

    canvas <- getElementsByTagName "canvas"
    addEventListener canvas "mousemove" $ onMouseMove ctx state

    doAnimation $ render state ctx mesh

