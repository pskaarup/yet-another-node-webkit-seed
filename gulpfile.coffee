###
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
###

# http://gulpjs.com/
# https://github.com/gulpjs/gulp
gulp          = require 'gulp'
# https://github.com/plus3network/gulp-less
less          = require 'gulp-less'
# https://github.com/miickel/gulp-angular-templatecache
ngTplCache    = require 'gulp-angular-templatecache'
# https://github.com/wearefractal/gulp-cached
cached        = require 'gulp-cached'
# https://github.com/wearefractal/gulp-coffee
coffee        = require 'gulp-coffee'
# https://github.com/wearefractal/gulp-concat
concat        = require 'gulp-concat'
# https://github.com/phated/gulp-jade
jade          = require 'gulp-jade'
# https://github.com/plus3network/gulp-less
less          = require 'gulp-less'
# https://github.com/hparra/gulp-rename
rename        = require 'gulp-rename'
# https://github.com/mikaelbr/gulp-notify
notify        = require 'gulp-notify'
# https://github.com/gulpjs/gulp-util
gutil         = require 'gulp-util'
# https://github.com/peter-vilja/gulp-clean
clean         = require 'gulp-clean'
# https://www.npmjs.org/package/gulp-order
order         = require 'gulp-order'
sourcemaps    = require 'gulp-sourcemaps'
bdi           = require './scripts/bowerDependencyInclusion.js'

# Create build system that automatically copy files from bower_components to target
# Base this from the package.js

###
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
  index.html            Result of index.jade compilation
  js
    app.js              The application
    app.tlp.js          AngularJS preloaded templateCache
  stat                  All static files
    images              All images
    vendor              All vendor scripts and files
      ...               vendor specific folders
  styles                Home of .less compilation
###

buildDir      = './build'
srcDir        = './src'
appDir        = '/app'
coffeeDir     = '/coffee'
partialsDir   = '/partials'
vendorDir     = '/vendor'
staticDir     = '/static'
stylesDir     = '/styles'
imageDir      = '/images'
jsDir         = '/js'
serverDir     = '/server'

srcAppDir     = srcDir + appDir
srcAppStatic  = srcAppDir + staticDir
buildAppDir   = buildDir + appDir 

bower_components = './bower_components'

# Object of the directory structure
structure =
  src:
    app:
      index     : srcAppDir
      coffee    : srcAppDir + coffeeDir
      partials : srcAppDir + partialsDir
      styles    : srcAppDir + stylesDir
      stat    :
        images  : srcAppStatic + imageDir
        vendor  : srcAppStatic + vendorDir
    server      : srcAppDir + serverDir
  build:
    index       : buildDir
    js          : buildAppDir + jsDir
    stat: 
      images    : buildAppDir + staticDir + imageDir
      vendor    : buildAppDir + staticDir + vendorDir
    styles      : buildAppDir + stylesDir
    partials   : buildDir + '/partials'


# Paths for src and dest of tasks
paths =
  dev:
    coffee:
      src: structure.src.app.coffee + '/**/*.coffee'
      dest: structure.build.js
    styles:
      src: [
        structure.src.app.styles + '/*.less'
        # '!'+structure.src.app.scripts+'_*'
      ]
      dest: structure.build.styles
    partials:
      src: structure.src.app.partials + '/**/*.jade'
      dest: structure.build.js
    jadeIndex:
      src: structure.src.app.index + '/index.jade'
      dest: structure.build.index
    vendor:
      src: structure.src.app.stat.vendor
      dest: structure.build.stat.vendor
  # rel:
  #   appScripts:
  #     src: buildDevJs

###
Compile ALL .coffee files into a single .js file
###
gulp.task 'dev.coffee', ->
  foo = gulp.src paths.dev.coffee.src
  # .pipe cached 'dev.coffee'
  # .pipe sourcemaps.init()
  .pipe coffee
      sourceMap: true
      sourceDest: paths.dev.coffee.dest
      # join: true
      # bare: false
    .on('error', (error) ->
      gutil.log error
      foo.pipe notify message: "Error found see console"
      )
  # .pipe sourcemaps.write(
  #     includeContent:true
  #     sourceRoot: structure.src.app.coffee
  #   )
  # .pipe concat 'app.js'
  .pipe gulp.dest paths.dev.coffee.dest
  .pipe notify message: 'Scripts task complete'

###
All bower supplied libs
###
gulp.task 'vendorJS', ->
  gulp.src bdi([
      './bower_components/jquery/dist/jquery.js'
      './bower_components/angular/angular.js'
      paths.dev.vendor.src + '/**/*.js'
      ], '.js')
  .pipe concat 'vendor.js'
  .pipe notify message: "Vendor JS compiled"
  .pipe gulp.dest paths.dev.vendor.dest

###
Complie lESS
###
gulp.task 'dev.styles', ->
  gulp.src paths.dev.styles.src
  # .pipe cached 'dev.styles'
  .pipe less(
    paths: [
      bower_components + '/bootstrap-less/less',
      paths.dev.styles.src + '/includes/**'
    ]
  ).on 'error', gutil.log
  .pipe notify message: "Styles compiled"
  .pipe gulp.dest paths.dev.styles.dest

###
JADE partials
SOME HOW I CAN'T GET ANGULAR TEMPLATES WORKING!
###
# LOCALS = {}
# gulp.task 'dev.partials2', ->
#   gulp.src paths.dev.partials.src
#   # .pipe cached 'dev.partials'
#   .pipe jade
#     locals: LOCALS
#   .pipe ngTplCache 'app.partials.js',
#       module: 'appPartials'
#       root: 'partials'
#   .pipe notify message: "partials compiled"
#   .pipe gulp.dest paths.dev.partials.dest
gulp.task 'dev.partials', ->
  gulp.src paths.dev.partials.src
  .pipe jade pretty: true
  .pipe notify message: 'partials compiled'
  .pipe gulp.dest structure.build.partials

###
JADE index.jade
###
gulp.task 'dev.index', ->
  gulp.src paths.dev.jadeIndex.src
  .pipe jade(
      pretty: true
    )
  .pipe notify message: "Index.jade compiled"
  .pipe gulp.dest paths.dev.jadeIndex.dest

gulp.task 'dev.clean.cache', ->
  cached.caches = {}

gulp.task 'dev.clean', ->
  gulp.src [
    structure.build.index
  ], read: false
  .pipe notify message: "Build cleaned"
  .pipe clean()

gulp.task 'copy.pack', ->
  gulp.src [structure.src.app.index + '/package.json']
  .pipe gulp.dest structure.build.index
  .pipe notify message: "package.json copied"

gulp.task 'default', [
  'watch'
]

gulp.task 'all', [
  'dev.index'
  'dev.partials'
  'dev.styles'
  'vendorJS'
  'dev.coffee'
  'copy.pack'
]

gulp.task 'watch', ['all'], ->
  gulp.watch [paths.dev.coffee.src], ['dev.coffee']
  gulp.watch bdi([
  ## might not need this here, could just watch paths.dev.vendor.src
      './bower_components/jquery/dist/jquery.js'
      './bower_components/angular/angular.js'
      paths.dev.vendor.src + '/**/*.js'
      ], '.js'), ['vendorJS']
  gulp.watch [paths.dev.styles.src], ['dev.styles']
  gulp.watch [paths.dev.partials.src], ['dev.partials']
  gulp.watch [paths.dev.jadeIndex.src], ['dev.index']
  gulp.watch [structure.src.app.index + '/package.json'], ['copy.pack']