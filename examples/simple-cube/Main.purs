module Main where

import           Control.Monad.Eff
import qualified Graphics.Three.Renderer as Renderer
import qualified Graphics.Three.Scene    as Scene
import qualified Graphics.Three.Scene.Object3D.Camera   as Camera
import qualified Graphics.Three.Material as Material
import qualified Graphics.Three.Geometry as Geometry
import qualified Graphics.Three.Scene.Object3D.Mesh     as Mesh
import           Graphics.Three.Types     
import           Examples.Common

import Debug.Trace


rotateCube :: forall eff. Context -> 
                          Mesh.Mesh -> 
                          Number -> 
                          Eff (three :: Three | eff) Unit
rotateCube (Context c) mesh n = do
    Mesh.rotateIncrement mesh 0 n 0
    Renderer.render c.renderer c.scene c.camera

main = do
    ctx@(Context c) <- initContext
    material        <- Material.createMeshBasic {}
    box             <- Geometry.createBox 100 100 100
    cube            <- Mesh.create box material

    Scene.addMesh c.scene cube

    doAnimation $ rotateCube ctx cube 0.01

