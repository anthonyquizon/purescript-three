module Examples.Cube where

import qualified Graphics.Three.Renderer as Renderer
import qualified Graphics.Three.Scene    as Scene
import qualified Graphics.Three.Camera   as Camera
import qualified Graphics.Three.Material as Material
import qualified Graphics.Three.Geometry as Geometry
import qualified Graphics.Three.Mesh     as Mesh

import Debug.Trace


width = 500
height = 500

main = do
    renderer <- Renderer.createWebGL
    scene    <- Scene.create
    camera   <- Camera.createPerspective 45 (width/height) 1 1000
    material <- Material.createMeshBasic
    box      <- Geometry.createBox 100 100 100
    cube     <- Mesh.create box material

    Camera.posZ camera 500

    Scene.addCamera scene camera
    Scene.addMesh scene cube

    Renderer.setSize renderer width height
    Renderer.appendToDomByID renderer "container"

    Renderer.render renderer scene camera

    return Unit

