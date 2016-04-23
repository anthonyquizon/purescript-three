module Examples.SimpleCube where

import           Prelude
import           Control.Monad.Eff
import           Control.Monad.Eff.Console
import qualified Graphics.Three.Renderer as Renderer
import qualified Graphics.Three.Scene    as Scene
import qualified Graphics.Three.Camera   as Camera
import qualified Graphics.Three.Material as Material
import qualified Graphics.Three.Geometry as Geometry
import qualified Graphics.Three.Object3D as Object3D
import           Graphics.Three.Types     
import           Examples.Common

rotateCube :: Context -> Object3D.Mesh -> Number -> ThreeEff Unit
rotateCube context mesh n = do
    Object3D.rotateIncrement mesh 0.0 n 0.0
    renderContext context

main = do
    ctx@(Context c) <- initContext Camera.Perspective
    material        <- Material.createMeshBasic {}
    box             <- Geometry.createBox 100.0 100.0 100.0
    cube            <- Object3D.createMesh box material

    Scene.addObject c.scene cube

    doAnimation $ rotateCube ctx cube 0.01

