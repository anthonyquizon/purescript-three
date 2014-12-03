module Graphics.Three.Geometry where

import           Control.Monad.Eff
import           Data.Function
import           Graphics.Three.Types
import           Graphics.Three.Util
import           Graphics.Three.Math.Vector

foreign import data Geometry :: *

create :: [Vector3] -> ThreeEff Geometry
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

getVertices :: Geometry -> ThreeEff [Vector3]
getVertices = ffi ["geometry", ""] "geometry.vertices"

setVertices :: Geometry -> [Vector3] -> ThreeEff [Vector3]
setVertices = fpi ["geometry", "vertices", ""] "geometry.vertices = vertices"

addVertex :: Geometry -> Vector3 -> ThreeEff [Vector3]
addVertex = fpi ["geometry", "vertex", ""] "geometry.vertices.push(vertex)"
