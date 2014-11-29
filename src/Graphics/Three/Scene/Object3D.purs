module Graphics.Three.Scene.Object3D where

import Graphics.Three.Math.Vector
import Graphics.Three.Types
import Graphics.Three.Util
import Control.Monad.Eff


class Object3D a where
    getPosition :: forall eff. a -> Eff (three :: Three | eff) Vector3 
    setPosition :: forall eff. a -> Number -> Number -> Number -> Eff (three :: Three | eff) Unit

    {--getRotationEuler :: forall eff. a -> Number -> Number -> Number -> Eff (three :: Three | eff) --}
    {--setRotationEuler :: forall eff. a -> Number -> Number -> Number -> Eff (three :: Three | eff) Unit--}



objectGetPosition :: forall eff a. a -> Eff (three :: Three | eff) Vector3 
objectGetPosition = ffi ["object", ""] "object.position"

objectSetPosition :: forall eff a. a -> Number -> Number -> Number -> Eff (three :: Three | eff) Unit
objectSetPosition = fpi ["object", "x", "y", "z", ""] "object.position.set(x, y, z)"


