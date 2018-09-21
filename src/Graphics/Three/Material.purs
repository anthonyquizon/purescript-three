module Graphics.Three.Material where

import Prelude (Unit)
import Effect (Effect)
import Graphics.Three.Util (ffi)

foreign import data MeshBasic   :: Type
foreign import data LineBasic   :: Type
foreign import data LineDashed  :: Type
foreign import data Shader :: Type


class Material a

instance materialMeshBasic :: Material MeshBasic
instance materialLineBasic :: Material LineBasic
instance materialShader :: Material Shader

createMeshBasic :: forall opt. {|opt} -> Effect MeshBasic
createMeshBasic = ffi ["param", ""] "new THREE.MeshBasicMaterial(param)"

createLineBasic :: forall opt. {|opt} -> Effect LineBasic
createLineBasic = ffi ["param", ""] "new THREE.LineBasicMaterial(param)"

createLineDashed :: forall opt. {|opt} -> Effect LineDashed
createLineDashed = ffi ["param", ""] "new THREE.LineDashedMaterial(param)"

createShader :: forall opt. {|opt} -> Effect Shader
createShader = ffi ["param", ""] "new THREE.ShaderMaterial(param)"

createShaderRaw :: forall opt. {|opt} -> Effect Shader
createShaderRaw = ffi ["param", ""] "new THREE.RawShaderMaterial(param)"

setUniform :: forall a. Shader -> String -> a -> Effect Unit
setUniform = ffi ["material", "key", "value", ""] "material.uniforms[key].value = value"

getUniform :: Shader -> String -> Effect Number
getUniform = ffi ["material", "key", ""] "material.uniforms[key].value"

getId :: forall a. Material a => a -> Effect Number
getId = ffi ["material", ""] "material.id"

getName :: forall a. Material a => a -> Effect String
getName = ffi ["material", ""] "material.name"

getOpacity :: forall a. Material a => a -> Effect Number
getOpacity = ffi ["material", ""] "material.opacity"

