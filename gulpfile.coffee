### http://gulpjs.com/ ###
### https://github.com/gulpjs/gulp ###
gulp          = require "gulp"
### https://github.com/plus3network/gulp-less ###
less          = require "gulp-less"
### https://github.com/miickel/gulp-angular-templatecache ###
ngTplCache    = require "gulp-angular-templatecache"
### https://github.com/wearefractal/gulp-cached ###
cached        = require "gulp-cached"
### https://github.com/wearefractal/gulp-coffee ###
coffee        = require "gulp-coffee"
### https://github.com/wearefractal/gulp-concat ###
concat        = require "gulp-concat"
### https://github.com/phated/gulp-jade ###
jade          = require "gulp-jade"
### https://github.com/plus3network/gulp-less ###
less          = require "gulp-less"
### https://github.com/hparra/gulp-rename ###
rename        = require "gulp-rename"
### https://github.com/mikaelbr/gulp-notify ###
notify        = require "gulp-notify"
### https://github.com/gulpjs/gulp-util ###
gutil         = require "gulp-util"
### https://github.com/peter-vilja/gulp-clean ###
clean         = require "gulp-clean"
### https://www.npmjs.org/package/gulp-order ###
order         = require "gulp-order"
###https://github.com/floridoo/gulp-sourcemaps ###
sourcemaps    = require "gulp-sourcemaps"
### https://github.com/robrich/gulp-if ###
gif           = require "gulp-if"
### https://github.com/terinjokes/gulp-uglify ###
uglify        = require "gulp-uglify"
### https://github.com/lazd/gulp-karma ###
karma         = require "gulp-karma"
### https://github.com/sirlantis/gulp-order ###
order         = require "gulp-order"
### https://github.com/mllrsohn/gulp-protractor ###
protractor    = require("gulp-protractor").protractor
### https://github.com/floatdrop/gulp-plumber ###
plumber       = require "gulp-plumber"
### https://github.com/sindresorhus/gulp-ruby-sass ###
rsass         = require "gulp-ruby-sass"
### https://github.com/sun-zheng-an/gulp-shell ###
shell         = require "gulp-shell"
### https://github.com/klei/gulp-inject ###
inject        = require "gulp-inject"
### https://github.com/sindresorhus/gulp-filter ###
filter        = require "gulp-filter"
### https://github.com/alexgorbatchev/gulp-print ###
print         = require "gulp-print"
### underscore... ###
_             = require "underscore"
### https://github.com/sindresorhus/gulp-debug ###
debug         = require "gulp-debug"

### default node ###
path          = require "path"
es            = require 'event-stream'

### homemade stuff ###
bdi           = require "./scripts/bowerDependencyInclusion.js"


env = process.env.NODE_ENV
isProduction = () ->
  env == "production"

slash           = path.sep


buildDir      = "build"
srcDir        = "src"
appDir        = "#{slash}app"
coffeeDir     = "#{slash}coffee"
templatesDir  = "#{slash}templates"
jadeDir       = "#{slash}jade"
vendorDir     = "#{slash}vendor"
staticDir     = "#{slash}static"
stylesDir     = "#{slash}styles"
imageDir      = "#{slash}images"
jsDir         = "#{slash}js"
serverDir     = "#{slash}server"
tests         = "#{slash}test"
unit          = "#{slash}unit"
e2e           = "#{slash}e2e"
nodeModules   = "#{slash}node_modules"
indexsDir     = "#{slash}indexs"

srcAppDir     = srcDir + appDir
srcTest       = srcDir + tests
srcAppStatic  = srcAppDir + staticDir
buildAppDir   = buildDir + appDir 

bower_components = ".#{slash}bower_components"

bootstrap_components = bower_components +
  "#{slash}bootstrap-sass-official#{slash}vendor#{slash}assets"

# Object of the directory structure
structure =
  src:
    app:
      index:      srcAppDir
      coffee:     srcAppDir + coffeeDir
      templates:  srcAppDir + templatesDir
      styles:     srcAppDir + stylesDir
      stat:
        images:   srcAppStatic + imageDir
        vendor:   srcAppStatic + vendorDir
        index:    srcAppStatic
      jade:       srcAppDir + jadeDir
      server:     srcAppDir + serverDir
      nodemodules:srcAppDir + nodeModules
      indexs:     srcAppDir + indexsDir
    test:
      index:      srcTest
      unit:       srcTest + unit
      e2e:        srcTest + e2e
  build:
    index:        buildDir
    js:           buildAppDir + jsDir
    stat: # no static folder in build
      images:     buildAppDir + imageDir
      vendor:     buildAppDir + vendorDir
      index:      buildAppDir
    styles:       buildAppDir + stylesDir
    templates:    buildDir + "#{slash}templates" # TODO: fix this inconsistency should be app/templates
    server:       buildDir + serverDir
    nodemodules:  buildDir + nodeModules


# Paths for src and dest of tasks
paths =
  dev:
    index:
      src:    structure.src.app.index
      dest:   structure.build.index
    coffee:
      src:    structure.src.app.coffee + "#{slash}**#{slash}*.coffee"
      dest:   structure.build.js
    styles:
      src:    structure.src.app.styles # no filetypes as same folder holds all style elements
      dest:   structure.build.styles
    templates:
      src:    structure.src.app.templates + "#{slash}**#{slash}*.jade"
      dest:   structure.build.js
    jadeIndex:
      src:    structure.src.app.index + "#{slash}index.jade"
      dest:   structure.build.index
    jadeTemplates:
      src:    structure.src.app.jade + "#{slash}**"
    indexs:
      src:    structure.src.app.indexs + "#{slash}**"
      dest:   structure.build.index
    vendor:
      src:    structure.src.app.stat.vendor # no specific file types in this folder
      dest:   structure.build.stat.vendor
    statics:
      src:    structure.src.app.stat.index # index so no file type
      dest:   structure.build.stat.index
    nodemodules:
      src:    structure.src.app.nodemodules # root of node_modules
      dest:   structure.build.nodemodules
    server:
      src:    structure.src.app.server + "#{slash}**#{slash}*.coffee"
      dest:   structure.build.server
    test:     structure.src.test.index
    units:
      src:    structure.src.test.unit + "#{slash}**#{slash}*.unit.coffee"
    e2e:
      src:    structure.src.test.e2e + "#{slash}**#{slash}*.e2e.coffee"

jsFileOrder = [
  "**jquery.js"
  "**bootstrap.js"
  "**tooltip.js"
  "**angular.js"
  "**angular**"
  "**underscore**"
  "**vendor**"
  "**app.coffee"
  "**controllers#{slash}**"
  "**services#{slash}**"
  "**filters#{slash}**"
  "**directives#{slash}**"
]

cssOrder = [
  "**bootstrap.*"
  "**app.*"
]

###
Imports from bower
###
bowerJS = bdi(".js")
bowerJS = bowerJS.concat [
  # Enter dependencies in bower_components that does not have a main field in .bower.json
  bower_components + "#{slash}bootstrap#{slash}dist#{slash}js#{slash}bootstrap.js"
  bower_components + "#{slash}angular-bootstrap#{slash}ui-bootstrap-tpls.js"
]

bowerCSS = bdi(".css") # any bower dependencies which has .css defined as main in .bower.json
bowerCSS = bowerCSS.concat [
  bower_components + "#{slash}bootstrap#{slash}dist#{slash}css#{slash}bootstrap.css"
]

appMinified = "app.min.js"
vendorMinified = "vendor.min.js"


urlifyPath = (url) ->
  winPath = new RegExp "\\\\", "g"
  url.replace winPath, '/'

compileCoffee = (taskName, stream, concatabale, concatFileName) ->
  stream
    .pipe plumber()
    .pipe coffee()
    .on "error", (error) ->
      gutil.log error
      stream.pipe notify message: error
  if concatabale
    stream.pipe gif isProduction(), concat concatFileName
  stream.pipe gif isProduction(), uglify()
    .pipe notify
      message: "#{taskName} task complete"
      onLast: true

createFakeStream = (filename, string) ->
  src = require('stream').Readable objectMode: true
  src._read = ->
    this.push new gutil.File
      cwd: ""
      base: ""
      path: filename
      contents: new Buffer string
    this.push null
  src

###
Compile ALL .coffee files into a single .js file
###
gulp.task "compile.coffee", ->
  stream = gulp.src [
    paths.dev.coffee.src
  ]
  res = compileCoffee "compile.coffee", stream, true, appMinified
  res.pipe gulp.dest paths.dev.coffee.dest

###
Compile src/app/server/**
###
gulp.task "compile.server", ->
  stream = gulp.src paths.dev.server.src
  res = compileCoffee "compile.server", stream, false, undefined
  res.pipe gulp.dest paths.dev.server.dest

gulp.task "copy.server.libs", ->
  gulp.src [
    structure.src.app.server + "#{slash}lib#{slash}**#{slash}*.js"
    !structure.src.app.server + "#{slash}**#{slash}*.coffee"
  ]
  .pipe gulp.dest paths.dev.server.dest + "#{slash}lib"
  .pipe notify
    message: "static files copied"
    onLast: true


# TODO run this task after all other files have been build, should make
# it easier to get paths correct
gulp.task "compile.index.files", ->
  js = bowerJS.concat [
    paths.dev.coffee.src
  ]

  jsPipe;
  if isProduction()
    ### Creating fake stream and adds minified files to this ###
    jsPipe = require('stream').Readable objectMode: true
    jsPipe._read = ->
      this.push new gutil.File
        cwd: ""
        base: ""
        path: appMinified
        contents: null
      this.push new gutil.File
        cwd: ""
        base: ""
        path: vendorMinified
        contents: null
      this.push null
  else
    jsPipe = gulp.src js, read:false
      .pipe order jsFileOrder

  css = [
    paths.dev.styles.src + "#{slash}scss#{slash}*.scss"
  ].concat bowerCSS
  
  cssPipe = gulp.src css, read:false
    .pipe order cssOrder

  indexFiles = paths.dev.indexs.src

  isBower = new RegExp ".*bower_components.*", "i"
  isCoffee = new RegExp "coffee$", "i"
  isSCSS = new RegExp "scss$", "i"

  gulp.src indexFiles
    .pipe filter ["**#{slash}*.jade"]
    .pipe jade
      pretty: true
    .pipe inject jsPipe,
      transform: (filepath) ->
        url;
        # if filepath contains "bower_components" => url = filename
        if isBower.test filepath
          url = urlifyPath appDir.substring(1, appDir.length) + vendorDir + "/" + path.basename filepath

        # if filepath ends in .coffee assume app#{slash}js#{slash}**#{slash}*
        if isCoffee.test filepath
          # find dir and replace with nothing
          urlPath = path.dirname(filepath).replace "#{slash}#{srcDir}#{appDir}#{coffeeDir}", ""
          fname = path.basename(filepath).replace isCoffee, "js"
          url = urlifyPath appDir.substring(1,appDir.length) + "#{jsDir}#{urlPath}/#{fname}"

        if filepath == "#{slash}#{appMinified}"
          url = urlifyPath appDir.substring(1,appDir.length) + "#{jsDir}#{filepath}"

        if filepath == "#{slash}#{vendorMinified}"
          url = urlifyPath appDir.substring(1, appDir.length) + vendorDir + filepath

        "<script src=\"#{url}\" type=\"text/javascript\"></script>"
      starttag: "<!-- inject:js-->"
      endtag: "<!-- endinject-->"
    .on "error", (e) -> gutil.log e

    .pipe inject cssPipe,
      transform: (filepath) ->
        url;
        # if bower
        if isBower.test filepath
          url =  urlifyPath appDir.substring(1, appDir.length) + vendorDir + "/" + path.basename filepath

        # if scss
        if isSCSS.test filepath
          urlPath = path.dirname(filepath).replace "#{slash}#{srcDir}#{appDir}#{stylesDir}", ""
          urlPath = urlPath.replace "#{slash}scss", ""
          fname = path.basename(filepath).replace isSCSS, 'css'
          url = urlifyPath appDir.substring(1, appDir.length) + "#{stylesDir}#{urlPath}/#{fname}"

        # url = filepath.replace /^build\//, ""
        "<link href=\"#{url}\" rel=\"stylesheet\" type=\"text/css\" />"
      starttag: "<!-- inject:css-->"
      endtag: "<!-- endinject-->"
    .on "error", (e) -> gutil.log e

    .pipe gulp.dest paths.dev.indexs.dest

###
Complie SCSS
TODO: change to stylus
###
gulp.task "compile.styles", ->
  devOptions = 
    style: "nested"
    precision: 10
    compass: true
    lineNumbers: true
    
  gulp.src [
    paths.dev.styles.src + "#{slash}scss#{slash}*.scss"
    !paths.dev.styles.src + "#{slash}scss#{slash}_*.scss"
  ]
  .pipe rsass devOptions
  .on "error", (e) -> gutil.log e
  .pipe gulp.dest paths.dev.styles.dest
  .pipe notify 
    message: "Styles completed"
    onLast: true

gulp.task "compile.angular.templates", ->
  gulp.src paths.dev.templates.src
  .pipe plumber()
  .pipe(jade(
    pretty: true
  )).on "error", gutil.log
  .pipe gulp.dest structure.build.templates
  .pipe notify 
    message: "Templates completed"
    onLast: true

gulp.task "dev.clean.cache", ->
  cached.caches = {}

gulp.task "clean", ->
  gulp.src [
    structure.build.index + "#{slash}**#{slash}*"
  ], read: false
  # .pipe notify 
  #   message: "Build cleaned"
  #   onLast: true
  .pipe clean()

gulp.task "runtimeDependencies", ["manage.package.json"], shell.task [
  "cd " + buildDir + "#{slash}; npm install"
]

###
Copies files from bower_component and src/app/vstatic/vendor
###
gulp.task "manage.vendor.js", ->
  vendorStream = gulp.src paths.dev.vendor.src + "#{slash}**#{slash}*.js"
    .pipe gif isProduction(), uglify()

  bowerStream = gulp.src bowerJS
    .pipe gif isProduction(), uglify()

  es.merge vendorStream, bowerStream
    .pipe gif isProduction(), concat vendorMinified
    .pipe gulp.dest paths.dev.vendor.dest

gulp.task "manage.vendor.css", ->
  vendorStream = gulp.src paths.dev.vendor.src + "#{slash}css#{slash}**#{slash}*.css"

  bowerStream = gulp.src bowerCSS

  es.merge vendorStream, bowerStream
    .pipe gulp.dest paths.dev.vendor.dest


gulp.task "manage.package.json", ->
  gulp.src [structure.src.app.index + "#{slash}package.json"]
    .pipe gulp.dest structure.build.index
    .pipe notify 
      message: "package.json copied"
      onLast: true

gulp.task "copy.static.files", ->
  gulp.src [
    paths.dev.statics.src + "#{slash}**#{slash}*"
    "!"+paths.dev.statics.src+"#{slash}**#{slash}*.js"
  ]
    .pipe gulp.dest paths.dev.statics.dest
    .pipe notify
      message: "static files copied"
      onLast: true

gulp.task "copy.style.fonts", ->
  gulp.src paths.dev.styles.src + "#{slash}fonts#{slash}**"
  .pipe gulp.dest paths.dev.styles.dest + "#{slash}fonts"
  .pipe notify
    message: "fonts copied"
    onLast: true

gulp.task "copy.bootstrap.fonts", ->
  gulp.src bootstrap_components + "#{slash}fonts#{slash}bootstrap#{slash}**#{slash}*"
  .pipe gulp.dest paths.dev.styles.dest + "#{slash}bootstrap"
  .pipe notify
    message: "bootstrap fonts copied"
    onLast: true

gulp.task "copy.dev.node_modules", ->
  gulp.src paths.dev.nodemodules.src + "#{slash}**"
  .pipe gulp.dest paths.dev.nodemodules.dest
  .pipe notify
    message: "node_module files copied"


###
TODO make watch task for this
TODO figure out how to run this in node-webkit
TODO change to new version of BDI
###
gulp.task "tests.unit" , ->
  gulp.src bdi("js", [
      ".#{slash}bower_components#{slash}jquery#{slash}dist#{slash}jquery.js"
      ".#{slash}bower_components#{slash}angular#{slash}angular.js"
      ".#{slash}bower_components#{slash}angular-mocks#{slash}angular-mocks.js"
      ],[
        paths.dev.coffee.src
        paths.dev.units.src
      ])
  .pipe karma
    configFile: paths.dev.test + "#{slash}karma.conf.js"
    action: "watch"
  .on("error", (err) ->
    throw err) # Make sure failed tests cause gulp to exit non-zero

gulp.task "tests.e2e", ->
  gulp.src [paths.dev.e2e.src]
  .pipe protractor(
    configFile: structure.src.test.index + "#{slash}protractor-conf.js"
    ).on("error", gutil.log)

gulp.task "default", [
  "watch"
]

gulp.task "build", [
  "compile.angular.templates"
  "compile.server"
  "compile.coffee"
  "compile.styles"
  "copy.static.files"
  "copy.style.fonts"
  "runtimeDependencies" # also copies src/app/package.json
  "compile.index.files"
  "manage.vendor.js"
  "manage.vendor.css"
], ->
  gulp.run "runtimeDependencies"

gulp.task "production", ["clean"], ->
  env = "production"
  gulp.start["build"]

gulp.task "watch", ["build"], ->
  # compile angular jade templates
  gulp.watch paths.dev.template.src, ["compile.angular.templates"]

  # compile server
  gulp.watch paths.dev.server.src, ["compile.server"]

  # compile app 
  gulp.watch [paths.dev.coffee.src], ["compile.coffee"]

  # compile scss
  gulp.watch paths.dev.styles.src + "#{slash}scss#{slash}*.scss", ["compile.styles"]

  # manage vendor js dependencies
  gulp.watch [
    paths.dev.vendor.src + "#{slash}**#{slash}*.js"
    paths.dev.vendor.src + "#{slash}css#{slash}**#{slash}*.css"
  ].concat(bowerJS).concat(bowerCSS), ["manage.vendor.js", "manage.vendor.css"]

  # copy static files
  gulp.watch paths.dev.statics.src + "#{slash}**", ["copy.static.files"]

  # copy source fonts
  gulp.watch paths.dev.styles.src + "#{slash}fonts#{slash}**", ["copy.style.fonts"]

  # copy package.json this is a prerequisite to runtimeDependencies
  gulp.watch [structure.src.app.index + "#{slash}package.json"], ["runtimeDependencies"]

  # manage vendor and bower js files
  gulp.watch bowerJS.concat [
    paths.dev.coffee.dest + "#{slash}**"
    paths.dev.vendor.dest + "#{slash}**"
    ], ["compile.index.files"]
