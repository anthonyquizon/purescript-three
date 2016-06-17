module Graphics.Three.Geometry where

import           Graphics.Three.Types (ThreeEff)
import           Graphics.Three.Util (fpi, ffi)
import           Graphics.Three.Math.Vector (Vector3)

foreign import data Geometry :: *

create :: Array Vector3 -> ThreeEff Geometry
create = ffi ["vertices", ""] 
    """ (function() { 
            var geometry = new THREE.Geometry(); 
            geometry.vertices = vertices
            return geometry;
        }())
    """

createBox :: Number -> Number -> Number -> ThreeEff Geometry
createBox = ffi ["width", "height", "depth", ""] 
    "new THREE.BoxGeometry(width, height, depth)"

createCircle :: Number -> Number -> Number -> Number -> ThreeEff Geometry
createCircle = ffi ["radius", "segments", "thetaStart", "thetaLength", ""] 
    "new THREE.CircleGeometry(radius, segments, thetaStart, thetaLength)"

createPlane :: Number -> Number -> Number -> Number -> ThreeEff Geometry
createPlane = ffi ["width", "height", "widthSegment", "heightSegment", ""] 
    "new THREE.PlaneGeometry(width, height, widthSegment, heightSegment);"

getVertices :: Geometry -> ThreeEff (Array Vector3)
getVertices = ffi ["geometry", ""] "geometry.vertices"

setVertices :: Geometry -> (Array Vector3) -> ThreeEff (Array Vector3)
setVertices = fpi ["geometry", "vertices", ""] "geometry.vertices = vertices"

addVertex :: Geometry -> Vector3 -> ThreeEff (Array Vector3)
addVertex = fpi ["geometry", "vertex", ""] "geometry.vertices.push(vertex)"
