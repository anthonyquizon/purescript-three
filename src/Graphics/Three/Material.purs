module Graphics.Three.Material where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Types
import Graphics.Three.Util

foreign import data Material :: *

create :: forall eff opt. {|opt} ->Eff (three :: Three | eff) Material
create = ffi ["param", ""] "new THREE.Material(param)"

createMeshBasic :: forall eff opt. {|opt} -> Eff (three :: Three | eff) Material
createMeshBasic = ffi ["param", ""] "new THREE.MeshBasicMaterial(param)"

createShader :: forall eff opt. {|opt} -> Eff (three :: Three | eff) Material
createShader = ffi ["param", ""] "new THREE.ShaderMaterial(param)"

setUniform :: forall eff a. Material -> String -> a -> Eff (three :: Three | eff) Unit
setUniform = ffi ["material", "key", "value", ""] "material.uniforms[key].value = value"

getUniform :: forall eff opt. Material -> String -> Eff (three :: Three | eff) Number
getUniform = ffi ["material", "key", ""] "material.uniforms[key].value"

