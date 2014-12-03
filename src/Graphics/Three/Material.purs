module Graphics.Three.Material where

import Control.Monad.Eff
import Data.Function
import Graphics.Three.Types
import Graphics.Three.Util

foreign import data MeshBasic   :: *
foreign import data LineBasic   :: *
foreign import data LineDashed  :: *
foreign import data Shader :: *


class Material a where
    getId      :: a -> ThreeEff Number
    getName    :: a -> ThreeEff String
    getOpacity :: a -> ThreeEff Number

instance materialMeshBasic :: Material MeshBasic where
    getId      = unsafeGetId
    getName    = unsafeGetName
    getOpacity = unsafeGetName

instance materialLineBasic :: Material LineBasic where
    getId      = unsafeGetId
    getName    = unsafeGetName
    getOpacity = unsafeGetName

instance materialShader :: Material Shader where
    getId      = unsafeGetId
    getName    = unsafeGetName
    getOpacity = unsafeGetName


createMeshBasic :: forall opt. {|opt} -> ThreeEff MeshBasic
createMeshBasic = ffi ["param", ""] "new THREE.MeshBasicMaterial(param)"

createLineBasic :: forall opt. {|opt} -> ThreeEff LineBasic
createLineBasic = ffi ["param", ""] "new THREE.LineBasicMaterial(param)"

createLineDashed :: forall opt. {|opt} -> ThreeEff LineDashed
createLineDashed = ffi ["param", ""] "new THREE.LineDashedMaterial(param)"

createShader :: forall opt. {|opt} -> ThreeEff Shader
createShader = ffi ["param", ""] "new THREE.ShaderMaterial(param)"

createShaderRaw :: forall opt. {|opt} -> ThreeEff Shader
createShaderRaw = ffi ["param", ""] "new THREE.RawShaderMaterial(param)"

setUniform :: forall a. Shader -> String -> a -> ThreeEff Unit
setUniform = ffi ["material", "key", "value", ""] "material.uniforms[key].value = value"

getUniform :: forall opt. Shader -> String -> ThreeEff Number
getUniform = ffi ["material", "key", ""] "material.uniforms[key].value"

unsafeGetId      = ffi ["material", ""] "material.id"
unsafeGetName    = ffi ["material", ""] "material.name"
unsafeGetOpacity = ffi ["material", ""] "material.opacity"
