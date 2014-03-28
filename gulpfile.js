var gulp 					= require('gulp');
var minifycss 		= require('gulp-minify-css');
var uglify 				= require('gulp-uglify');
var concat 				= require('gulp-concat');



gulp.task('js', function(){
	return gulp.src([
						'js/modernizr.js',
						'js/jquery-2.1.0.min.js',
						'js/jquery.parallax.js',
						'js/tweenmax.min.js',
						'js/jquery.superscrollorama.js',
						'js/iscroll.js',
						'js/helpers.js',
						'js/point.js',
						'js/main.js'
					])
					.pipe(concat('dist.js'))
					.pipe(uglify())
					.pipe(gulp.dest('js/'))
});

gulp.task('css', function(){
	return gulp.src('css/main.css')
					.pipe(minifycss())
					.pipe(gulp.dest('css/'))
});


gulp.task('default', ['js', 'css']);
	// var server = livereload();

	// gulp.watch(paths.src.css, function(e){
	// 	gulp.run('stylus');
	// 	// server.changed(e.path)
	// 	// console.log(e.path);
	// });

	// gulp.watch(paths.src.js, function(e){
	// 	gulp.run('coffee');
	// 	server.changed(e.path)
	// });

	// gulp.watch(paths.src.tests, function(e){
	// 	gulp.run('coffee:tests');
	// 	server.changed(e.path)
	// });

	// gulp.watch(paths.src.kit, function(e){
	// 	gulp.run('kit:jade');
	// 	server.changed(e.path);
	// });

	// gulp.watch(paths.src.index, function(e){
	// 	gulp.run('index:jade');
	// 	server.changed(e.path);
	// });

	// gulp.watch(paths.src.partials, function(e){
	// 	gulp.run('kit:jade');
	// 	gulp.run('index:jade');
	// 	server.changed(e.path);
	// });

	// gulp.watch(paths.src.templates, function(e){
	// 	gulp.run('index:jade');
	// 	server.changed(e.path);
	// });

// });











