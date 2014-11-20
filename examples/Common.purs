module Examples.Common where

import           Control.Monad.Eff
import           Control.Monad.Eff.Ref
import           DOM
import qualified Graphics.Three.Renderer    as Renderer
import qualified Graphics.Three.Material    as Material
import qualified Graphics.Three.Geometry    as Geometry
import qualified Graphics.Three.Scene       as Scene
import qualified Graphics.Three.Scene.Object3D.Camera      as Camera
import qualified Graphics.Three.Scene.Object3D.Mesh as Mesh
import           Graphics.Three.Types     
import qualified Math           as Math


newtype Context = Context {
          renderer :: Renderer.Renderer 
        , scene    :: Scene.Scene
        , camera   :: Camera.Camera
        , mesh     :: Mesh.Mesh
        , material :: Material.Material
    }

context :: Renderer.Renderer -> Scene.Scene -> 
           Camera.Camera     -> Mesh.Mesh   -> 
           Material.Material -> Context
context r s c me ma = Context {
          renderer: r
        , scene:    s
        , camera:   c
        , mesh:     me
        , material: ma
    }


doAnimation :: forall eff. Eff (three :: Three | eff) Unit -> Eff (three :: Three | eff) Unit
doAnimation animate = do
    animate
    requestAnimationFrame $ doAnimation animate


foreign import requestAnimationFrame """
    function requestAnimationFrame(callback) {
        return function() {
            return window.requestAnimationFrame(callback);
        }
    }
    """ :: forall eff. Eff eff Unit -> Eff eff Unit
