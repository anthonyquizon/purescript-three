module Main where

import           Control.Monad.Eff
import qualified Graphics.Three.Renderer as Renderer
import qualified Graphics.Three.Scene    as Scene
import qualified Graphics.Three.Scene.Object3D.Camera   as Camera
import qualified Graphics.Three.Material as Material
import qualified Graphics.Three.Geometry as Geometry
import qualified Graphics.Three.Scene.Object3D.Mesh     as Mesh
import           Graphics.Three.Types     

import Debug.Trace


width = 500
height = 500

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
    Mesh.rotateIncrement mesh 0 n 0
    Renderer.render renderer scene camera

main = do
    renderer <- Renderer.createWebGL {antialias: true}
    scene    <- Scene.create
    camera   <- Camera.createPerspective 45 (width/height) 1 1000
    material <- Material.createMeshBasic {}
    box      <- Geometry.createBox 100 100 100
    cube     <- Mesh.create box material

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

