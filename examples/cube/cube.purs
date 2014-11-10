module Examples.Cube where

import Debug.Trace
import Graphics.Three.Renderer
import Graphics.Three.Scene
import Graphics.Three.Camera


width = 400
height = 500

main = do
    renderer <- createWebGLRenderer
    scene <- createScene
    camera <- createPerspectiveCamera 45 (width/height) 1 1000

    sceneAddCamera scene camera

    rendererSetSize renderer width height
    appendRendererByID renderer "container"

    return Unit

