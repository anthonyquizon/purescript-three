module Graphics.Three.Scene.Object3D.Types where

import Graphics.Three.Math.Vector
import Graphics.Three.Types
import Graphics.Three.Util
import Control.Monad.Eff


class Object3D a where
    getPosition :: forall eff. a -> Eff (three :: Three | eff) Vector3 
    setPosition :: forall eff. a -> Number -> Number -> Number -> Eff (three :: Three | eff) Unit

