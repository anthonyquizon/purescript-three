
module Graphics.Three.Util where

import Data.Foreign.EasyFFI 

foreign import data Three :: !

ffi = unsafeForeignFunction
fpi = unsafeForeignProcedure

