module Main where

import           Control.Monad
import           Control.Monad.Eff
import           Control.Monad.Eff.Ref
import           DOM
import qualified Graphics.Three.Renderer    as Renderer
import qualified Graphics.Three.Material    as Material
import qualified Graphics.Three.Geometry    as Geometry
import qualified Graphics.Three.Scene       as Scene
import qualified Graphics.Three.Scene.Camera      as Camera
import qualified Graphics.Three.Scene.Mesh as Mesh
import           Graphics.Three.Types     
import qualified Graphics.Three.Scene.Object3D as Object3D
import qualified Math           as Math

import Examples.Common
import Debug.Trace

lineProps = {
          cols   : 30
        , rows   : 10
        , padCol : 50
        , padRow : 50
    }


initUniforms = {
        amount: {
             "type" : "f"
            , value : 0.0
        }
    }

vertexShader :: String
vertexShader = """
    #ifdef GL_ES
    precision highp float;
    #endif

    void main() {
        gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
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

renderContext :: forall eff. RefVal StateRef -> Context -> [Mesh.Mesh] ->
                 Eff (trace :: Trace, ref :: Ref, three :: Three | eff) Unit
renderContext state (Context c) me = do
    modifyRef state $ \(StateRef s) -> stateRef (s.frame + 1) s.pos s.prev
    s'@(StateRef s) <- readRef state

    --modify mesh positions
    
    Renderer.render c.renderer c.scene c.camera


createMesh :: forall eff. Dimensions -> Scene.Scene -> Material.Material -> 
              Number -> Number -> [Mesh.Mesh] -> Pos -> 
              Eff (three :: Three | eff) [Mesh.Mesh]
createMesh dims scene mat colWidth rowHeight acc (Pos p) = do
    let x =  (p.x + lineProps.padCol/2) - (dims.width/2)
        y = -(p.y + lineProps.padCol/2) + (dims.height/2)
    
    plane <- Geometry.createPlane w h 1 1
    mesh  <- Mesh.create plane mat

    Object3D.setPosition mesh x y 0
    Scene.addMesh scene mesh

    return $ mesh:acc
    where
        w = colWidth  - lineProps.padCol
        h = rowHeight - lineProps.padRow

createMeshList :: forall eff. Scene.Scene -> Material.Material -> Eff (dom :: DOM, three :: Three | eff) [Mesh.Mesh]
createMeshList scene mat = do
    canvas <- getElementsByTagName "canvas"
    dims   <- nodeDimensions canvas
    
    let colWidth  = dims.width  / (lineProps.cols + 1)
        rowHeight = dims.height / (lineProps.rows + 1)
        
    let l = gridList lineProps.cols lineProps.rows $ 
            \i j -> pos (i*colWidth) (j*rowHeight)
            
    foldM (createMesh dims scene mat colWidth rowHeight) [] l


main = do
    ctx@(Context c) <- initContext
    state           <- newRef initStateRef
    material        <- Material.createShader {
                          uniforms: initUniforms
                        , vertexShader:   vertexShader
                        , fragmentShader: fragmentShader
                    }

    meshList <- createMeshList c.scene material

    doAnimation $ renderContext state ctx meshList


