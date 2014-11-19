'use strict'

var gulp      	= require('gulp')
  , purescript 	= require('gulp-purescript')
  , connect     = require('gulp-connect')
  , fs          = require('fs')


var bower_src = [
    'bower_components/purescript-*/src/**/*.purs'
];

var library = {
    src: ['src/**/*.purs'],
    dest: 'build/output',
    options : {}
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

function compileExample(name) {

    var dir  = 'examples/' + name + '/'
      , src  = library.src.concat(dir + '*.purs')
      , dest = dir + 'output/'
      , opts = {
            output: 'main.js', 
            main: true
        }

    compile(src, dest, opts);
}

function forExamples(callback) {
    var dirs = fs.readdirSync('examples');
    
    for (var i=0; i<dirs.length; i++) {
        var name = dirs[i];

        if (!fs.lstatSync("examples/" + name).isDirectory() ||
            dirs[i] == "bower_components")
        {
            continue;
        }

        callback(dirs[i]);
    }
}

gulp.task('dotPsci', function() {
    var psci = purescript.dotPsci();

	psci.on('error', function(e) {
		console.error(e.message);
		psci.end();
	});

	return gulp.src(library.src.concat(bower_src))
               .pipe(psci);
});

gulp.task('build', function() {
    compile(library.src, library.dest, library.options);
});

gulp.task('examples', function() {
    forExamples(compileExample);
});

gulp.task('server', function() {
    connect.server({
        root: 'examples'
    });
});

forExamples(function(name) {
    gulp.task('example-' + name, function() {
        compileExample(name);
    });
});

gulp.task('watch', ['build', 'examples'], function() {
	gulp.watch(library.src, ['build', 'dotPsci']);

    forExamples(function(name) {
        var src = 'examples/' + name + '/**/*.purs'
        gulp.watch(src, ['example-' + name]);
    });

    //TODO build docs
});

gulp.task('default', ['build', 'examples', 'dotPsci']);

