module Examples.Cube where

import qualified Graphics.Three.Renderer as Renderer
import qualified Graphics.Three.Scene    as Scene
import qualified Graphics.Three.Camera   as Camera

import Debug.Trace


width = 400
height = 500

main = do
    renderer <- Renderer.createWebGL
    scene <- Scene.create
    camera <- Camera.createPerspective 45 (width/height) 1 1000

    Scene.addCamera scene camera

    Renderer.setSize renderer width height
    Renderer.appendToDomByID renderer "container"

    return Unit

