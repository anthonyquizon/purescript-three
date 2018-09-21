module Examples.LineArray where

import Prelude (Unit, ($), bind, discard, (*), (/), pure, negate, (+), (-))
import Effect (Effect)
import Effect.Ref as Ref
import Data.Array (foldM, (:))
import Graphics.Three.Camera      as Camera
import Graphics.Three.Geometry    as Geometry
import Graphics.Three.Material    as Material
import Graphics.Three.Renderer    as Renderer
import Graphics.Three.Scene       as Scene
import Graphics.Three.Object3D    as Object3D
import Graphics.Three.Math.Vector (createVec3)
import Data.Int                   as Int
import Math                       as Math

import Examples.Common (Dimensions, Context(Context), Pos(Pos), StateRef(StateRef), doAnimation, initStateRef,
    initContext, pos, gridList, nodeDimensions, getElementsByTagName, renderContext, stateRef)


lineProps = {
          cols   : 30
        , rows   : 10
        , padCol : 10.0
        , padRow : 10.0
        , radius : 20.0 -- influence radius
    }

initUniforms :: { amount :: { "type" :: String, value :: Number } }
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

v3 = createVec3

render :: Ref.Ref StateRef -> Context -> Array Object3D.Line -> Effect Unit
render state context lines = do
    Ref.modify_ (\(StateRef s) -> stateRef (s.frame + 1.0) s.pos s.prev) state
    s'@(StateRef s) <- Ref.read state

    renderContext context


createLine :: forall a. Material.Material a => Dimensions -> 
                                               Scene.Scene -> 
                                               a -> 
                                               Number -> 
                                               Number -> 
                                               Array Object3D.Line ->
                                               Pos -> 
                                               Effect (Array Object3D.Line)
createLine dims scene mat colWidth rowHeight acc (Pos p) = do
    let x =  (p.x + lineProps.padCol/2.0) - (dims.width/2.0)
        y = -(p.y + lineProps.padCol/2.0) + (dims.height/2.0)
    
    geometry <- Geometry.create [v3 0.0 (h/2.0) 0.0, v3 0.0 (-h/2.0) 0.0]
    line     <- Object3D.createLine geometry mat Object3D.LineStrip

    Object3D.setPosition line x y 0.0
    Scene.addObject scene line

    pure $ line:acc
    where
        w = colWidth  - lineProps.padCol
        h = rowHeight - lineProps.padRow

createLineList :: forall a. Material.Material a => Scene.Scene -> a -> Effect (Array Object3D.Line)
createLineList scene mat = do
    canvas <- getElementsByTagName "canvas"
    dims   <- nodeDimensions canvas
    
    let colWidth  = dims.width  / (Int.toNumber lineProps.cols)
        rowHeight = dims.height / (Int.toNumber lineProps.rows)
        
    let l = gridList lineProps.cols lineProps.rows $ 
            \i j -> pos (Math.floor ((Int.toNumber i) *colWidth )) (Math.floor ((Int.toNumber j) * rowHeight))
            
    foldM (createLine dims scene mat colWidth rowHeight) [] l

main :: Effect Unit
main = do
    ctx@(Context c) <- initContext Camera.Orthographic
    state           <- Ref.new initStateRef
    material        <- Material.createLineBasic { color: "red", linewidth: 10 }

    lineList <- createLineList c.scene material

    doAnimation $ render state ctx lineList


