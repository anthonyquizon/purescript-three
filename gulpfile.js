'use strict'

var gulp       = require('gulp')
  , purescript = require('gulp-purescript')
  , connect    = require('gulp-connect')
  , fs         = require('fs')
  , plumber    = require('gulp-plumber')


var OPTIONS = {
    lib: {
        src: [
            'src/**/*.purs'
          , 'bower_components/purescript-*/src/**/*.purs'
        ],
        watch: ['src/**/*.purs'],
        dst: 'build/output',
        options : {}
    },
    common: {
        src: "examples/Common.purs"
    }
}


function compile(src, dst, options) {
	var psc = purescript.psc(options);

	gulp.src(src)
        .pipe(plumber())
        .pipe(psc)
        .pipe(gulp.dest(dst))
        .pipe(connect.reload())
}

function compileExample(name) {

    var dir  = 'examples/' + name + '/'
      , lib  = OPTIONS.lib.src
      , dst  = dir + 'output/'
      , src  = lib.concat(OPTIONS.common.src)
                  .concat(dir + '*.purs')
      , opts = {
            output: 'main.js', 
            main: true
        }

    compile(src, dst, opts);
}

function forExamples(callback) {
    var dirs = fs.readdirSync('examples');
    
    for (var i=0; i<dirs.length; i++) {
        var name    = dirs[i]
          , isDir   = fs.lstatSync("examples/" + name).isDirectory()
          , isBower = dirs[i] == "bower_components"

        if (!isDir || isBower) {
            continue;
        }

        callback(dirs[i]);
    }
}

gulp.task('dotPsci', function() {
    var psci = purescript.dotPsci()

	gulp.src(OPTIONS.lib.src)
        .pipe(psci)
});

gulp.task('build', function() {
    var opts = OPTIONS.lib

    compile(
        opts.src, 
        opts.dst, 
        opts.options
    );
});

gulp.task('examples', function() {
    //TODO generate examples index.html file
    forExamples(compileExample);
});

gulp.task('server', function() {
    connect.server({
        root: 'examples'
      //, livereload: true
    });
});

forExamples(function(name) {
    gulp.task('example-' + name, function() {
        compileExample(name);
    });
});

gulp.task('watch', ['build', 'examples', 'server'], function() {
    gulp.watch(OPTIONS.lib.src, ['build', 'examples', 'dotPsci']);
    gulp.watch(OPTIONS.common.src, ['examples']);

    forExamples(function(name) {
        var src = 'examples/' + name + '/**/*.purs'
        gulp.watch(src, ['example-' + name]);
    });

    //TODO build docs
});

gulp.task('default', ['build', 'examples', 'dotPsci']);

