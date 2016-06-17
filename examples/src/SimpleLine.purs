module Examples.SimpleLine where

import Prelude
import Control.Monad
import Control.Monad.Eff
import Control.Monad.Eff.Ref
import Control.Monad.Eff.Console
import DOM
import Graphics.Three.Camera      as Camera
import Graphics.Three.Geometry    as Geometry
import Graphics.Three.Material    as Material
import Graphics.Three.Renderer    as Renderer
import Graphics.Three.Scene       as Scene
import Graphics.Three.Object3D    as Object3D
import Graphics.Three.Math.Vector
import Graphics.Three.Types
import Math           as Math

import Examples.Common

v3 = createVec3

rotateLine :: forall eff. Context -> Object3D.Line -> Number -> Eff (three :: Three | eff) Unit
rotateLine context line n = do
    Object3D.rotateIncrement line 0.0 0.0 n
    renderContext context

main = do
    ctx@(Context c) <- initContext Camera.Orthographic
    material        <- Material.createLineBasic { color: "red", linewidth: 10 }
    geometry        <- Geometry.create [v3 0.0 100.0 0.0, v3 0.0 (-100.0) 0.0]
    line            <- Object3D.createLine geometry material Object3D.LineStrip

    Scene.addObject c.scene line

    doAnimation $ rotateLine ctx line 0.01

