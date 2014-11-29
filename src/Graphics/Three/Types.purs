module Graphics.Three.Types where

import Control.Monad.Eff

foreign import data Three :: !

type ThreeEff a = forall e. Eff (three :: Three | e) a

