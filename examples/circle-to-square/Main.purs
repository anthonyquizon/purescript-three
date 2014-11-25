module Main where

import           Control.Monad.Eff
import           Control.Monad.Eff.Ref
import           DOM
import qualified Graphics.Three.Renderer    as Renderer
import qualified Graphics.Three.Material    as Material
import qualified Graphics.Three.Geometry    as Geometry
import qualified Graphics.Three.Scene       as Scene
import qualified Graphics.Three.Scene.Object3D.Camera      as Camera
import qualified Graphics.Three.Scene.Object3D.Mesh as Mesh
import           Graphics.Three.Types     
import qualified Math           as Math

import Examples.Common
import Debug.Trace


interval = 200
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
clamp n = Math.min 1.0 $ Math.max (0.0) n

--TODO square wave with ease functions

morphShape :: forall eff. Material.Material -> Number -> Eff (trace :: Trace, three :: Three | eff) Unit
morphShape ma n = do
    let a = (Math.sin $ ((2*Math.pi) / interval) * (n % interval)) * 0.5 + 0.5
    Material.setUniform ma "amount" $ clamp a
    return unit

renderContext :: forall a eff. RefVal Number -> Context -> Material.Material ->
                       Eff ( trace :: Trace, ref :: Ref, three :: Three | eff) Unit
renderContext frame (Context c) mat = do
    
    modifyRef frame $ \f -> f + 1
    f <- readRef frame

    morphShape mat f

    Renderer.render c.renderer c.scene c.camera

main = do
    ctx@(Context c) <- init
    frame           <- newRef 0
    material        <- Material.createShader {
                            uniforms: initUniforms
                            , vertexShader:   vertexShader
                            , fragmentShader: fragmentShader
                        }
    circle          <- Geometry.createCircle radius 32 0 (2*Math.pi)
    mesh            <- Mesh.create circle material

    Scene.addMesh c.scene mesh

    doAnimation $ renderContext frame ctx material

