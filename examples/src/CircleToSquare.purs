module Examples.CircleToSquare where

import Prelude (Unit, bind, discard, max, pure, unit, ($), (*), (+), (/))
import Effect (Effect)
import Effect.Ref as Ref
import Graphics.Three.Camera   as Camera
import Graphics.Three.Material as Material
import Graphics.Three.Object3D as Object3D
import Graphics.Three.Geometry as Geometry
import Graphics.Three.Scene    as Scene
import Math (min, sin, pi, (%))

import Examples.Common


interval = 200.0
radius   = 50.0

initUniforms = {
        amount: {
             "type" : "f"
            , value : 0.0
        },
        radius: {
             "type" : "f"
            , value : radius
        }
    }

vertexShader :: String
vertexShader = """
    #ifdef GL_ES
    precision highp float;
    #endif

    uniform float amount;
    uniform float radius;

    float morph(in float p) {
        float eps = 0.1;
        float scale = radius*1.6;

        if (p < -eps) {
           return mix(p, -scale, amount); //TODO uniform width
        }
        if (p > eps) {
           return mix(p, scale, amount);
        }

        return 0.0;
    }

    void main() {
        vec3 pos = position;

        pos.x = morph(pos.x);
        pos.y = morph(pos.y);
        
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

clamp :: Number -> Number
clamp n = min 1.0 $ max (0.0) n

--TODO square wave with ease functions

morphShape :: Material.Shader -> Number -> Effect Unit
morphShape ma n = do
    let a = (sin $ ((2.0 * pi) / interval) * (n % interval)) * 0.5 + 0.5
    Material.setUniform ma "amount" $ clamp a
    pure unit

render :: Ref.Ref Number -> Context -> Material.Shader -> Effect Unit
render frame context mat = do
    
    Ref.modify_ (\f -> f + 1.0) frame
    f <- Ref.read frame

    morphShape mat f

    renderContext context

main :: Effect Unit
main = do
    ctx@(Context c) <- initContext Camera.Orthographic
    frame           <- Ref.new 0.0
    material        <- Material.createShader {
                            uniforms: initUniforms
                            , vertexShader:   vertexShader
                            , fragmentShader: fragmentShader
                        }
    circle          <- Geometry.createCircle radius 32.0 0.0 (2.0 * pi)
    mesh            <- Object3D.createMesh circle material

    Scene.addObject c.scene mesh

    doAnimation $ render frame ctx material

