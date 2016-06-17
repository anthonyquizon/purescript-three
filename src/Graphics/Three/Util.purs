
module Graphics.Three.Util where

import Data.Foreign.EasyFFI 

ffi :: forall a. Array String -> String -> a
ffi = unsafeForeignFunction
fpi :: forall a. Array String -> String -> a
fpi = unsafeForeignProcedure

