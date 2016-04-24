module Graphics.Three.Types where

import Control.Monad.Eff (Eff)

foreign import data Three :: !

type ThreeEff  a   = forall e. Eff (three :: Three | e) a
type ThreeEffN e a = Eff (three :: Three | e) a

