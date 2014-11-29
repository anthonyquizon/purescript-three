module Graphics.Three.Geometry where

import           Control.Monad.Eff
import           Data.Function
import           Graphics.Three.Types
import           Graphics.Three.Util

foreign import data Geometry :: *

createBox :: Number -> Number -> Number -> ThreeEff Geometry
createBox = ffi ["width", "height", "depth", ""] 
    "new THREE.BoxGeometry(width, height, depth)"

createCircle :: Number -> Number -> Number -> Number -> ThreeEff Geometry
createCircle = ffi ["radius", "segments", "thetaStart", "thetaLength", ""] 
    "new THREE.CircleGeometry(radius, segments, thetaStart, thetaLength)"

createPlane :: Number -> Number -> Number -> Number -> ThreeEff Geometry
createPlane = ffi ["width", "height", "widthSegment", "heightSegment", ""] 
    "new THREE.PlaneGeometry(width, height, widthSegment, heightSegment);"

