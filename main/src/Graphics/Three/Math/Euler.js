/* global exports */
"use strict";

// module Graphics.Three.Math.Euler

exports.createEulerFn = function(x) {
    return function(y) {
        return function(z) {
            return new THREE.Euler(x, y, z);
        };
    };
};