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
#https://github.com/floridoo/gulp-sourcemaps
sourcemaps    = require 'gulp-sourcemaps'
bdi           = require './scripts/bowerDependencyInclusion.js'
# https://github.com/robrich/gulp-if
gif           = require 'gulp-if'
# https://github.com/terinjokes/gulp-uglify
uglify        = require 'gulp-uglify'
# https://github.com/lazd/gulp-karma
karma         = require 'gulp-karma'
# https://github.com/sirlantis/gulp-order
order         = require 'gulp-order'
# https://github.com/VFK/gulp-html-replace
# use this to allow at development to have each .coffee matched with a .js 
# while in production only use one .js file.
# TODO test if it can remove in pipe
htmlReplace   = require 'gulp-html-replace'
# https://github.com/mllrsohn/gulp-protractor
protractor    = require('gulp-protractor').protractor

env = process.env.NODE_ENV
isProduction = () ->
  env == 'production'

###
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
###

buildDir      = './build'
srcDir        = './src'
appDir        = '/app'
coffeeDir     = '/coffee'
templatesDir   = '/templates'
vendorDir     = '/vendor'
staticDir     = '/static'
stylesDir     = '/styles'
imageDir      = '/images'
jsDir         = '/js'
serverDir     = '/server'
tests         = '/test'
unit          = '/unit'
e2e           = '/e2e'

srcAppDir     = srcDir + appDir
srcTest       = srcDir + tests
srcAppStatic  = srcAppDir + staticDir
buildAppDir   = buildDir + appDir 

bower_components = './bower_components'

# Object of the directory structure
structure =
  src:
    app:
      index:    srcAppDir
      coffee:   srcAppDir + coffeeDir
      templates: srcAppDir + templatesDir
      styles:   srcAppDir + stylesDir
      stat:
        images: srcAppStatic + imageDir
        vendor: srcAppStatic + vendorDir
    server:     srcAppDir + serverDir
    test:
      index:    srcTest
      unit:     srcTest + unit
      e2e:      srcTest + e2e
  build:
    index:      buildDir
    js:         buildAppDir + jsDir
    stat: 
      images:   buildAppDir + staticDir + imageDir
      vendor:   buildAppDir + staticDir + vendorDir
    styles:     buildAppDir + stylesDir
    templates:   buildDir + '/templates' # TODO: fix this inconsistency should be app/templates


# Paths for src and dest of tasks
paths =
  dev:
    coffee:
      src:    structure.src.app.coffee + '/**/*.coffee'
      dest:   structure.build.js
    styles:
      src:    structure.src.app.styles
      dest:   structure.build.styles
    templates:
      src:    structure.src.app.templates + '/**/*.jade'
      dest:   structure.build.js
    jadeIndex:
      src:    structure.src.app.index + '/index.jade'
      dest:   structure.build.index
    vendor:
      src:    structure.src.app.stat.vendor
      dest:   structure.build.stat.vendor
    test:     structure.src.test.index
    units:
      src:    structure.src.test.unit + '/**/*.unit.coffee'
    e2e:
      src:    structure.src.test.e2e + '/**/*.e2e.coffee'

###
Compile ALL .coffee files into a single .js file
###
gulp.task 'dev.coffee', ->
  foo = gulp.src paths.dev.coffee.src
  # .pipe gif !isProduction(), sourcemaps.init()
  .pipe coffee()
      # join: true
      # sourceMap: !isProduction env
      # sourceDest: paths.dev.coffee.dest
    .on('error', (error) ->
      gutil.log error
      foo.pipe notify message: "Error found see console"
      )
  # .pipe gif !isProduction(), sourcemaps.write() # sourcemaps.write({sourceRoot: paths.dev.coffee.src})
  .pipe gif isProduction(), concat 'app.min.js'
  .pipe gif isProduction(), uglify()
  .pipe gulp.dest paths.dev.coffee.dest
  .pipe notify 
    message: 'Scripts task complete'
    onLast: true

###
All bower supplied libs
###
gulp.task 'vendorJS', ->
  gulp.src bdi('.js', [ # TODO need better implementation of BDI
      './bower_components/jquery/dist/jquery.js'
      './bower_components/angular/angular.js'
      './bower_components/bootstrap-less/js/*.js'
      './bower_components/angular-bootstrap/ui-bootstrap-tpls.js'
      paths.dev.vendor.src + '/**/*.js'
      ])
  .pipe order [
    'jquery.js' # Locking order dependency
    'angular.js'
    'tooltip.js' # damit bootstrap
  ]
  .pipe concat 'vendor.js'
  .pipe gif isProduction, uglify()
  .pipe notify 
    message: "Vendor JS compiled"
    onLast: true
  .pipe gulp.dest paths.dev.vendor.dest

###
Complie lESS
###
gulp.task 'dev.styles', ->
  gulp.src paths.dev.styles.src + '/*.less'
  # .pipe cached 'dev.styles'
  .pipe less(
    paths: [
      bower_components + '/bootstrap-less/less',
      paths.dev.styles.src + '/includes/**'
    ]
    compress: isProduction()
  ).on 'error', (e) -> gutil.log e
  .pipe notify 
    message: "Styles compiled"
    onLast: true
  .pipe gulp.dest paths.dev.styles.dest

###
JADE templates
SOME HOW I CAN'T GET ANGULAR TEMPLATES WORKING!
###
# LOCALS = {}
# gulp.task 'dev.templates2', ->
#   gulp.src paths.dev.templates.src
#   # .pipe cached 'dev.templates'
#   .pipe jade
#     locals: LOCALS
#   .pipe ngTplCache 'app.templates.js',
#       module: 'apptemplates'
#       root: 'templates'
#   .pipe notify message: "templates compiled"
#   .pipe gulp.dest paths.dev.templates.dest
gulp.task 'dev.templates', ->
  gulp.src paths.dev.templates.src
  .pipe jade pretty: true
  .pipe notify 
    message: 'templates compiled'
    onLast: true
  .pipe gulp.dest structure.build.templates

###
JADE index.jade
###
gulp.task 'dev.index', ->
  gulp.src paths.dev.jadeIndex.src
  .pipe jade(
      pretty: true
    )
  .pipe gif isProduction(), htmlReplace
    js: 'app/js/app.min.js'
  .pipe notify 
    message: "Index.jade compiled"
    onLast: true
  .pipe gulp.dest paths.dev.jadeIndex.dest

gulp.task 'dev.clean.cache', ->
  cached.caches = {}

gulp.task 'clean', ->
  gulp.src [
    structure.build.index + '/**/*'
  ], read: false
  .pipe notify 
    message: "Build cleaned"
    onLast: true
  .pipe clean()

gulp.task 'clean4production', ->
  gulp.src [
    paths.dev.coffee.dest + '/**/*'
  ], read: false
  .pipe gif isProduction(), notify 
    message: "Js cleaned for production"
    onLast: true
  .pipe gif isProduction(), clean()

gulp.task 'copy.pack', ->
  gulp.src [structure.src.app.index + '/package.json']
  .pipe gulp.dest structure.build.index
  .pipe notify 
    message: "package.json copied"
    onLast: true

gulp.task 'tests.unit' , ->
  gulp.src bdi('js', [
      './bower_components/jquery/dist/jquery.js'
      './bower_components/angular/angular.js'
      './bower_components/angular-mocks/angular-mocks.js'
      ],[
        paths.dev.coffee.src
        paths.dev.units.src
      ])
  .pipe karma
    configFile: paths.dev.test + '/karma.conf.js'
    action: 'watch'
  .on('error', (err) ->
    throw err) #M ake sure failed tests cause gulp to exit non-zero

gulp.task 'tests.e2e', ->
  gulp.src [paths.dev.e2e.src]
  .pipe protractor(
    configFile: structure.src.test.index + '/protractor-conf.js'
    ).on('error', (e) -> throw e)


gulp.task 'default', [
  'watch'
]

gulp.task 'all', [
  'clean4production'
  'dev.index'
  'dev.templates'
  'dev.styles'
  'vendorJS'
  'dev.coffee'
  'copy.pack'
]

gulp.task 'watch', ['all'], ->
  gulp.watch [paths.dev.coffee.src], ['dev.coffee']
  gulp.watch bdi('.js', [
  ## might not need this here, could just watch paths.dev.vendor.src
      './bower_components/jquery/dist/jquery.js'
      './bower_components/angular/angular.js'
      paths.dev.vendor.src + '/**/*.js'
      ]), ['vendorJS']
  gulp.watch [paths.dev.styles.src + '/**/*.less'], ['dev.styles']
  gulp.watch [paths.dev.templates.src], ['dev.templates']
  gulp.watch [paths.dev.jadeIndex.src], ['dev.index']
  gulp.watch [structure.src.app.index + '/package.json'], ['copy.pack']