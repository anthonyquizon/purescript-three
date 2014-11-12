module Graphics.Three.Geometry where

import           Control.Monad.Eff
import           Data.Function
import           Graphics.Three.Types
import           Graphics.Three.Util

foreign import data Geometry :: *

createBox :: forall eff. Number -> Number -> Number -> Eff (three :: Three | eff) Geometry
createBox = ffi ["x", "y", "z", ""] "new THREE.BoxGeometry(x, y, z)"

