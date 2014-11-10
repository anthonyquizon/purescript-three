'use strict'

var gulp      	= require('gulp')
  , purescript 	= require('gulp-purescript')
  , connect     = require('gulp-connect')


var bower_src = [
    'bower_components/purescript-*/src/**/*.purs'
];

var library = {
    src: ['src/**/*.purs'],
    dest: 'build/output',
    options : {}
};

var examples = {
    cube : {
        src : ['examples/cube/cube.purs'],
        dest: 'examples/cube/',
        options : {
            output: 'cube.js',
            main: 'Examples.Cube'
        }
    }
};

function compile(src, dest, options) {
	var psc = purescript.psc(options);

	psc.on('error', function(e) {
		console.error(e.message);
		psc.end();
	});

	return gulp.src(src.concat(bower_src))
               .pipe(psc)
               .pipe(gulp.dest(dest));
}

gulp.task('build', function() {
    compile(library.src, library.dest, library.options);
    //TODO PSCI
});

gulp.task('examples', function() {
    var cube_src = library.src.concat(examples.cube.src);

    compile(
        cube_src, 
        examples.cube.dest, 
        examples.cube.options
    );

    connect.server({
        root: 'examples'
    });
});

gulp.task('watch', ['build'], function() {
	gulp.watch(library.src, ['build']);
    //TODO build docs
});

gulp.task('default', ['build']);

