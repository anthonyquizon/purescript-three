purescript-three
================

Purescript bindings for Threejs

# Build purescript-three

```
bower install
pulp build
bower link
```

# Build examples

```
cd examples/
bower link purescript-three
pulp browserify --main Examples.CircleToSquare --to output/circleToSquare.js
pulp browserify --main Examples.LineArray --to output/lineArray.js
pulp browserify --main Examples.MotionStretch --to output/motionStretch.js
pulp browserify --main Examples.SimpleCube --to output/simpleCube.js
pulp browserify --main Examples.SimpleLine --to output/simpleLine.js

open resources/*.html  // in your favorite browser
```
