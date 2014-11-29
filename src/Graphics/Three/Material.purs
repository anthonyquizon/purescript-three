module Graphics.Three.Material where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Types
import Graphics.Three.Util

foreign import data Material :: *

create :: forall opt. {|opt} -> ThreeEff Material
create = ffi ["param", ""] "new THREE.Material(param)"

createMeshBasic :: forall opt. {|opt} -> ThreeEff Material
createMeshBasic = ffi ["param", ""] "new THREE.MeshBasicMaterial(param)"

createShader :: forall opt. {|opt} -> ThreeEff Material
createShader = ffi ["param", ""] "new THREE.ShaderMaterial(param)"

setUniform :: forall a. Material -> String -> a -> ThreeEff Unit
setUniform = ffi ["material", "key", "value", ""] "material.uniforms[key].value = value"

getUniform :: forall opt. Material -> String -> ThreeEff Number
getUniform = ffi ["material", "key", ""] "material.uniforms[key].value"

