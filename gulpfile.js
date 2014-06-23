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
var appDir, bdi, bootstrap_components, bower_components, buildAppDir, buildDir, cached, clean, coffee, coffeeDir, concat, e2e, env, gif, gulp, gutil, htmlReplace, imageDir, isProduction, jade, jsDir, karma, less, ngTplCache, notify, order, paths, plumber, protractor, rename, rsass, serverDir, sourcemaps, srcAppDir, srcAppStatic, srcDir, srcTest, staticDir, structure, stylesDir, templatesDir, tests, uglify, unit, vendorDir;

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

karma = require('gulp-karma');

order = require('gulp-order');

htmlReplace = require('gulp-html-replace');

protractor = require('gulp-protractor').protractor;

plumber = require('gulp-plumber');

rsass = require('gulp-ruby-sass');

env = process.env.NODE_ENV;

isProduction = function() {
  return env === 'production';
};


/*
Directory structure
./_release/ will hold the final executalbe files

./src
  app                   Home of application source
    index.jade          complied into build/index.html
    coffee              Uncomplied coffee scripts
    templates           Angular templates
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

buildDir = 'build';

srcDir = 'src';

appDir = '/app';

coffeeDir = '/coffee';

templatesDir = '/templates';

vendorDir = '/vendor';

staticDir = '/static';

stylesDir = '/styles';

imageDir = '/images';

jsDir = '/js';

serverDir = '/server';

tests = '/test';

unit = '/unit';

e2e = '/e2e';

srcAppDir = srcDir + appDir;

srcTest = srcDir + tests;

srcAppStatic = srcAppDir + staticDir;

buildAppDir = buildDir + appDir;

bower_components = './bower_components';

bootstrap_components = bower_components + '/bootstrap-sass-official/vendor/assets';

structure = {
  src: {
    app: {
      index: srcAppDir,
      coffee: srcAppDir + coffeeDir,
      templates: srcAppDir + templatesDir,
      styles: srcAppDir + stylesDir,
      stat: {
        images: srcAppStatic + imageDir,
        vendor: srcAppStatic + vendorDir,
        index: srcAppStatic
      }
    },
    server: srcAppDir + serverDir,
    test: {
      index: srcTest,
      unit: srcTest + unit,
      e2e: srcTest + e2e
    }
  },
  build: {
    index: buildDir,
    js: buildAppDir + jsDir,
    stat: {
      images: buildAppDir + imageDir,
      vendor: buildAppDir + vendorDir,
      index: buildAppDir
    },
    styles: buildAppDir + stylesDir,
    templates: buildDir + '/templates'
  }
};

paths = {
  dev: {
    coffee: {
      src: structure.src.app.coffee + '/**/*.coffee',
      dest: structure.build.js
    },
    styles: {
      src: structure.src.app.styles,
      dest: structure.build.styles
    },
    templates: {
      src: structure.src.app.templates + '/**/*.jade',
      dest: structure.build.js
    },
    jadeIndex: {
      src: structure.src.app.index + '/index.jade',
      dest: structure.build.index
    },
    vendor: {
      src: structure.src.app.stat.vendor,
      dest: structure.build.stat.vendor
    },
    statics: {
      src: structure.src.app.stat.index,
      dest: structure.build.stat.index
    },
    test: structure.src.test.index,
    units: {
      src: structure.src.test.unit + '/**/*.unit.coffee'
    },
    e2e: {
      src: structure.src.test.e2e + '/**/*.e2e.coffee'
    }
  }
};


/*
Compile ALL .coffee files into a single .js file
 */

gulp.task('dev.coffee', function() {
  var foo;
  return foo = gulp.src(paths.dev.coffee.src).pipe(plumber()).pipe(coffee()).on('error', function(error) {
    gutil.log(error);
    return foo.pipe(notify({
      message: "Error found see console"
    }));
  }).pipe(gif(isProduction(), concat('app.min.js'))).pipe(gif(isProduction(), uglify())).pipe(gulp.dest(paths.dev.coffee.dest)).pipe(notify({
    message: 'Scripts task complete',
    onLast: true
  }));
});


/*
All bower supplied libs
 */

gulp.task('vendorJS', function() {
  return gulp.src(bdi('.js', ['./bower_components/jquery/dist/jquery.js', './bower_components/angular/angular.js', './bower_components/bootstrap/js/*.js', './bower_components/angular-bootstrap/ui-bootstrap-tpls.js', paths.dev.vendor.src + '/**/*.js'])).pipe(order(['jquery.js', 'angular.js', 'tooltip.js'])).pipe(concat('vendor.js')).pipe(gif(isProduction, uglify())).pipe(gulp.dest(paths.dev.vendor.dest)).pipe(notify({
    message: "Vendor JS compiled",
    onLast: true
  }));
});


/*
Complie SCSS
 */

gulp.task('styles', function() {
  var devOptions;
  devOptions = {
    style: 'nested',
    precision: 10,
    compass: true,
    loadPath: ['bower_components/bootstrap-sass-official/vendor/assets/stylesheets']
  };
  return gulp.src('src/app/styles/scss/*.scss').pipe(rsass(devOptions)).on('error', function(e) {
    return gutil.log(e);
  }).pipe(gulp.dest('build/app/styles')).pipe(notify({
    message: "Styles completed",
    onLast: true
  }));
});

gulp.task('dev.templates', function() {
  return gulp.src(paths.dev.templates.src).pipe(plumber()).pipe(jade({
    pretty: true
  })).on('error', gutil.log).pipe(gulp.dest(structure.build.templates)).pipe(notify({
    message: "Templates completed",
    onLast: true
  }));
});


/*
JADE index.jade
 */

gulp.task('dev.index', function() {
  return gulp.src(paths.dev.jadeIndex.src).pipe(plumber()).pipe(jade({
    pretty: true
  })).on('error', gutil.log).pipe(gif(isProduction(), htmlReplace({
    js: 'app/js/app.min.js'
  }))).pipe(gulp.dest(paths.dev.jadeIndex.dest)).pipe(notify({
    message: "index.html completed",
    onLast: true
  }));
});

gulp.task('dev.clean.cache', function() {
  return cached.caches = {};
});

gulp.task('clean', function() {
  return gulp.src([structure.build.index + '/**/*'], {
    read: false
  }).pipe(clean());
});

gulp.task('clean4production', function() {
  return gulp.src([paths.dev.coffee.dest + '/**/*'], {
    read: false
  }).pipe(gif(isProduction(), notify({
    message: "Js cleaned for production",
    onLast: true
  }))).pipe(gif(isProduction(), clean()));
});

gulp.task('copy.pack', function() {
  return gulp.src([structure.src.app.index + '/package.json']).pipe(gulp.dest(structure.build.index)).pipe(notify({
    message: "package.json copied",
    onLast: true
  }));
});

gulp.task('copy.static', function() {
  return gulp.src([paths.dev.statics.src + '/**/*', '!' + paths.dev.statics.src + '/**/*.js']).pipe(gulp.dest(paths.dev.statics.dest)).pipe(notify({
    message: "static files copied",
    onLast: true
  }));
});

gulp.task('copy.bootstrap.fonts', function() {
  return gulp.src(bootstrap_components + '/fonts/bootstrap/**/*').pipe(gulp.dest(paths.dev.styles.dest + '/bootstrap')).pipe(notify({
    message: "bootstrap fonts copied",
    onLast: true
  }));
});

gulp.task('tests.unit', function() {
  return gulp.src(bdi('js', ['./bower_components/jquery/dist/jquery.js', './bower_components/angular/angular.js', './bower_components/angular-mocks/angular-mocks.js'], [paths.dev.coffee.src, paths.dev.units.src])).pipe(karma({
    configFile: paths.dev.test + '/karma.conf.js',
    action: 'watch'
  })).on('error', function(err) {
    throw err;
  });
});

gulp.task('tests.e2e', function() {
  return gulp.src([paths.dev.e2e.src]).pipe(protractor({
    configFile: structure.src.test.index + '/protractor-conf.js'
  }).on('error', gutil.log));
});

gulp.task('default', ['watch']);

gulp.task('all', ['clean4production', 'dev.index', 'dev.templates', 'styles', 'vendorJS', 'dev.coffee', 'copy.pack', 'copy.static', 'copy.bootstrap.fonts']);

gulp.task('watch', ['all'], function() {
  gulp.watch([paths.dev.coffee.src], ['dev.coffee']);
  gulp.watch(bdi('.js', ['./bower_components/jquery/dist/jquery.js', './bower_components/angular/angular.js', paths.dev.vendor.src + '/**/*.js']), ['vendorJS']);
  gulp.watch([paths.dev.styles.src + '/**/*.scss'], ['styles']);
  gulp.watch([paths.dev.templates.src], ['dev.templates']);
  gulp.watch([paths.dev.jadeIndex.src], ['dev.index']);
  gulp.watch([structure.src.app.index + '/package.json'], ['copy.pack']);
  return gulp.watch([paths.dev.statics.src + '/**/*'], ['copy.static']);
});
