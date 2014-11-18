module Main where

import           Control.Monad.Eff
import           DOM
import qualified Graphics.Three.Renderer as Renderer
import qualified Graphics.Three.Scene    as Scene
import qualified Graphics.Three.Camera   as Camera
import qualified Graphics.Three.Material as Material
import qualified Graphics.Three.Geometry as Geometry
import qualified Graphics.Three.Mesh     as Mesh
import           Graphics.Three.Types     
import qualified Math           as Math

import Debug.Trace


data Shape = Shape {
          mesh :: Mesh.Mesh
    }

width    = 500
height   = 500
interval = 20

vertexShader :: String
vertexShader = """
    #ifdef GL_ES
    precision highp float;
    #endif

    void main() {
        gl_Position = projectionMatrix * modelViewMatrix * vec4(position,1.0);
    }
"""

fragmentShader :: String 
fragmentShader = """
    #ifdef GL_ES
    precision highp float;
    #endif

    void main() {
        gl_FragColor = vec4(1.0,0.0,1.0,1.0);
    }
"""


doAnimation :: forall eff. Eff (three :: Three | eff) Unit -> Eff (three :: Three | eff) Unit
doAnimation animate = do
    animate
    requestAnimationFrame $ doAnimation animate

rotateCube :: forall eff. Renderer.Renderer -> 
                          Scene.Scene -> 
                          Camera.Camera -> 
                          Mesh.Mesh -> 
                          Number -> 
                          Eff (three :: Three | eff) Unit
rotateCube renderer scene camera mesh n = do
    --modulo 60
    --timing
    Renderer.render renderer scene camera

{--circleMorphSquare :: forall eff. Shape -> Eff (three :: Three | eff) Unit
circleMorphSquare circle fac = do
    -- get fraction
    return Unit
--}

main = do
    renderer <- Renderer.createWebGL {antialias: true}
    scene    <- Scene.create
    camera   <- Camera.createPerspective 45 (width/height) 1 1000
    material <- Material.createShader {
                      vertexShader:   vertexShader
                    , fragmentShader: fragmentShader
                }
    circle   <- Geometry.createCircle 30 32 0 (2*Math.pi)
    cube     <- Mesh.create circle material

    Camera.posZ camera 500

    Scene.addCamera scene camera
    Scene.addMesh scene cube

    Renderer.setSize renderer width height
    Renderer.appendToDomByID renderer "container"

    doAnimation $ rotateCube renderer scene camera cube 0.01

    return Unit


foreign import requestAnimationFrame """
    function requestAnimationFrame(callback) {
        return function() {
            return window.requestAnimationFrame(callback);
        }
    }
    """ :: forall eff. Eff eff Unit -> Eff eff Unit

