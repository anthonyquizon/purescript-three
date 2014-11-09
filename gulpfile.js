'use strict'

var gulp      	= require('gulp')
  , purescript 	= require('gulp-purescript')
  , concat      = require('gulp-concat')

var paths = {
	src: 'src/**/*.purs',
	dest: 'build/output',
	bowerSrc: [
	  'bower_components/purescript-*/src/**/*.purs'
	],
	manualReadme: 'docsrc/README.md',
	apiDest: 'build/API.md',
	readmeDest: 'README.md'
};

gulp.task('compile', function() {
	var psc = purescript.pscMake({
		// Compiler options
		output: paths.dest
	});

	psc.on('error', function(e) {
		console.error(e.message);
		psc.end();
	});
    
	return gulp.src([paths.src]
               .concat(paths.bowerSrc))
               .pipe(psc)
});

gulp.task('watch', ['build'], function() {
	gulp.watch(paths.src, ['build']);
	//gulp.watch(paths.manualReadme, ['concatDocs']);
});

gulp.task('build', ['compile']);

gulp.task('default', ['build']);

