/* global exports */
"use strict";

// module Graphics.Three.Math.Euler

exports.create = function(x) {
    return function(y) {
        return function(z) {
            return new THREE.Euler(x, y, z);
        };
    };
};