// Generated by CoffeeScript 1.7.1

/*
  TODO READ https://www.npmjs.org/package/karma-nodewebkit-launcher
  TODO READ https://www.npmjs.org/package/karma-phantomjs-launcher
  Build system should compile into buildDevRoot with source maps and 
  if required copy source coffee files.

  The release task should take the structure from buildDevRoot except some ignored files
  and uglify these into the 

  https://github.com/gulpjs/gulp-util
  noop()

  Returns a stream that does nothing but pass data straight through.

  gulp.task('scripts', function() {
    gulp.src('src/** /*.js') # (the space after ** is to resolve recursive comments)
      .pipe(concat('script.js'))
      .pipe(gutil.env.type === 'production' ? uglify() : gutil.noop())
      .pipe(gulp.dest('dist/');
  });
 */
var appDir, bdi, bower_components, buildAppDir, buildDir, cached, clean, coffee, coffeeDir, concat, env, gif, gulp, gutil, imageDir, isProduction, jade, jsDir, less, ngTplCache, notify, order, partialsDir, paths, rename, serverDir, sourcemaps, srcAppDir, srcAppStatic, srcDir, staticDir, structure, stylesDir, uglify, vendorDir;

gulp = require('gulp');

less = require('gulp-less');

ngTplCache = require('gulp-angular-templatecache');

cached = require('gulp-cached');

coffee = require('gulp-coffee');

concat = require('gulp-concat');

jade = require('gulp-jade');

less = require('gulp-less');

rename = require('gulp-rename');

notify = require('gulp-notify');

gutil = require('gulp-util');

clean = require('gulp-clean');

order = require('gulp-order');

sourcemaps = require('gulp-sourcemaps');

bdi = require('./scripts/bowerDependencyInclusion.js');

gif = require('gulp-if');

uglify = require('gulp-uglify');

env = process.env.NODE_ENV;


/*
Directory structure
./_release/ will hold the final executalbe files

./src
  app                   Home of application source
    index.jade          complied into build/index.html
    coffee              Uncomplied coffee scripts
    partials           Angular partials
    styles              Home of less files
    stat                static files
      images            images
      vendor            3rd party items

./tests                 Home of karma tests
  e2e                   End to end tests
  karma.conf.js         Karma setup file
  unit                  Unit tests

./build
  develop
    index.html          Result of index.jade compilation
    js
      app.js            The application
      app.tlp.js        AngularJS preloaded templateCache
    stat                All static files
      images            All images
      vendor            All vendor scripts and files
        ...             vendor specific folders
    styles              Home of .less compilation
  release               excatly same structure as develop but minified
 */

buildDir = './build';

srcDir = './src';

appDir = '/app';

coffeeDir = '/coffee';

partialsDir = '/partials';

vendorDir = '/vendor';

staticDir = '/static';

stylesDir = '/styles';

imageDir = '/images';

jsDir = '/js';

serverDir = '/server';

srcAppDir = srcDir + appDir;

srcAppStatic = srcAppDir + staticDir;

buildAppDir = buildDir + appDir;

bower_components = './bower_components';

structure = {
  src: {
    app: {
      index: srcAppDir,
      coffee: srcAppDir + coffeeDir,
      partials: srcAppDir + partialsDir,
      styles: srcAppDir + stylesDir,
      stat: {
        images: srcAppStatic + imageDir,
        vendor: srcAppStatic + vendorDir
      }
    },
    server: srcAppDir + serverDir
  },
  build: {
    index: buildDir,
    js: buildAppDir + jsDir,
    stat: {
      images: buildAppDir + staticDir + imageDir,
      vendor: buildAppDir + staticDir + vendorDir
    },
    styles: buildAppDir + stylesDir,
    partials: buildDir + '/partials'
  }
};

paths = {
  dev: {
    coffee: {
      src: structure.src.app.coffee + '/**/*.coffee',
      dest: structure.build.js
    },
    styles: {
      src: [structure.src.app.styles + '/*.less'],
      dest: structure.build.styles
    },
    partials: {
      src: structure.src.app.partials + '/**/*.jade',
      dest: structure.build.js
    },
    jadeIndex: {
      src: structure.src.app.index + '/index.jade',
      dest: structure.build.index
    },
    vendor: {
      src: structure.src.app.stat.vendor,
      dest: structure.build.stat.vendor
    }
  }
};

isProduction = function(enviroment) {
  return enviroment === 'production';
};


/*
Compile ALL .coffee files into a single .js file
 */

gulp.task('dev.coffee', function() {
  var foo;
  return foo = gulp.src(paths.dev.coffee.src).pipe(coffee({
    sourceMap: !isProduction(env),
    sourceDest: paths.dev.coffee.dests
  })).on('error', function(error) {
    gutil.log(error);
    return foo.pipe(notify({
      message: "Error found see console"
    }));
  }).pipe(gif(isProduction(env), uglify())).pipe(gulp.dest(paths.dev.coffee.dest)).pipe(notify({
    message: 'Scripts task complete',
    onLast: true
  }));
});


/*
All bower supplied libs
 */

gulp.task('vendorJS', function() {
  return gulp.src(bdi(['./bower_components/jquery/dist/jquery.js', './bower_components/angular/angular.js', paths.dev.vendor.src + '/**/*.js'], '.js')).pipe(concat('vendor.js')).pipe(gif(isProduction, uglify())).pipe(notify({
    message: "Vendor JS compiled",
    onLast: true
  })).pipe(gulp.dest(paths.dev.vendor.dest));
});


/*
Complie lESS
 */

gulp.task('dev.styles', function() {
  return gulp.src(paths.dev.styles.src).pipe(less({
    paths: [bower_components + '/bootstrap-less/less', paths.dev.styles.src + '/includes/**'],
    compress: isProduction(env)
  }).on('error', gutil.log)).pipe(notify({
    message: "Styles compiled",
    onLast: true
  })).pipe(gulp.dest(paths.dev.styles.dest));
});


/*
JADE partials
SOME HOW I CAN'T GET ANGULAR TEMPLATES WORKING!
 */

gulp.task('dev.partials', function() {
  return gulp.src(paths.dev.partials.src).pipe(jade({
    pretty: true
  })).pipe(notify({
    message: 'partials compiled',
    onLast: true
  })).pipe(gulp.dest(structure.build.partials));
});


/*
JADE index.jade
 */

gulp.task('dev.index', function() {
  return gulp.src(paths.dev.jadeIndex.src).pipe(jade({
    pretty: true
  })).pipe(notify({
    message: "Index.jade compiled",
    onLast: true
  })).pipe(gulp.dest(paths.dev.jadeIndex.dest));
});

gulp.task('dev.clean.cache', function() {
  return cached.caches = {};
});

gulp.task('clean', function() {
  return gulp.src([structure.build.index + '/**/*'], {
    read: false
  }).pipe(notify({
    message: "Build cleaned",
    onLast: true
  })).pipe(clean());
});

gulp.task('clean.maps', function() {
  return gulp.src([structure.build.index + '/**/*.map'], {
    read: false
  }).pipe(gif(isProduction(env), notify({
    message: "Maps removed",
    onLast: true
  }))).pipe(gif(isProduction(env), clean()));
});

gulp.task('copy.pack', function() {
  return gulp.src([structure.src.app.index + '/package.json']).pipe(gulp.dest(structure.build.index)).pipe(notify({
    message: "package.json copied",
    onLast: true
  }));
});

gulp.task('default', ['watch']);

gulp.task('all', ['clean.maps', 'dev.index', 'dev.partials', 'dev.styles', 'vendorJS', 'dev.coffee', 'copy.pack']);

gulp.task('watch', ['all'], function() {
  gulp.watch([paths.dev.coffee.src], ['dev.coffee']);
  gulp.watch(bdi(['./bower_components/jquery/dist/jquery.js', './bower_components/angular/angular.js', paths.dev.vendor.src + '/**/*.js'], '.js'), ['vendorJS']);
  gulp.watch([paths.dev.styles.src], ['dev.styles']);
  gulp.watch([paths.dev.partials.src], ['dev.partials']);
  gulp.watch([paths.dev.jadeIndex.src], ['dev.index']);
  return gulp.watch([structure.src.app.index + '/package.json'], ['copy.pack']);
});
