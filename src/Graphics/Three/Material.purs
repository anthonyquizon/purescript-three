module Graphics.Three.Material where

import Prelude (Unit)
import Graphics.Three.Types (ThreeEff)
import Graphics.Three.Util (ffi)

foreign import data MeshBasic   :: *
foreign import data LineBasic   :: *
foreign import data LineDashed  :: *
foreign import data Shader :: *


class Material a

instance materialMeshBasic :: Material MeshBasic
instance materialLineBasic :: Material LineBasic
instance materialShader :: Material Shader

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

getUniform :: Shader -> String -> ThreeEff Number
getUniform = ffi ["material", "key", ""] "material.uniforms[key].value"

getId :: forall a. (Material a) => a -> ThreeEff Number
getId = ffi ["material", ""] "material.id"

getName :: forall a. (Material a) => a -> ThreeEff String
getName = ffi ["material", ""] "material.name"

getOpacity :: forall a. (Material a) => a -> ThreeEff Number
getOpacity = ffi ["material", ""] "material.opacity"

