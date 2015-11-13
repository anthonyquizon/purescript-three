/* global exports */
"use strict";

// module Graphics.Three.Math.Vector

exports.createVec3 = function(x) {
    return function(y) {
        return function(z) {
            return new THREE.Vector3(x, y, z);
        };
    };
};