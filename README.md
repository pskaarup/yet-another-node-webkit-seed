# Yet another node-webkit seed
`yet-another-node-webkit-seed` is a skeleton for development of multiplayform Desktop Applications through the use of [node-webkit](https://github.com/rogerwang/node-webkit) as a `node` and `webkit` runtime environment for ECMAscript and html based applications

## Dependencies & Installation
The skeleton has a few dependencies including those found in `bower.json` and `package.json`

* Download [node-webkit](https://github.com/rogerwang/node-webkit#downloads) prebuilt binaries to a directory of your choice (outside . directory) and include in `$PATH`
    
    Note the version number as you will have to set this in `Gruntfile.coffee` under `nodewebkit:` where it specifies the `version:`

	For mac: `export PATH=~/path/to/node-webkit/0.9.2/node-webkit.app/Contents/MacOS:$PATH`

    For windows: TODO, someone help me :)

## Technologies in use
* Frontend
    * [AngularJS](angularjs.org)
    * Generate template caches using $templateCache TODO implement is feature or find plugin
    * [CoffeeScript](coffeescript.org)
    * UglifyJS - no enabled yet
    * CSS using [LESS](lesscss.org)
* Backend - backend of compiled applications
    * [Nedb](https://github.com/louischatriot/nedb)
* Testing - Units and e2e
    * Karma - TODO Create setup
    * Jasmin
    * Protractor - TODO Find plugin for chromium execution, or use phantomJS
* Build System
    * [Gulp](https://github.com/gulpjs/gulp) powered buildsystem applying compilation and execution of front, backend and testing


## Node-webkit
[How to package and distribute your apps](https://github.com/rogerwang/node-webkit/wiki/How-to-package-and-distribute-your-apps)

> [quote](https://github.com/rogerwang/node-webkit/wiki/How-to-package-and-distribute-your-apps#which-files-should-be-shipped)

> Apart from the binary files, there're some other files you should also ship, see instructions for different platforms below.

> And since the binary is based on Chromium, multiple open source license notices are needed including the MIT License, the LGPL, the BSD, the Ms-PL and an MPL/GPL/LGPL tri-license. (This doesn't apply to your code and you don't have to open source your code)

## Directory structure
```
./_release/ will hold the final executalbe files
./src/
  app/                  Home of application source
    index.jade          complied into build/index.html
    package.json        json file containing setup for the node-webkit executable
    coffee/             Uncomplied coffee scripts
    partials/           Angular partials
    styles/             Home of less files
    static/             staticic files
      images/           images
      vendor/           3rd party items - NOTICE: see bower dependency inclusion
./tests/                Home of karma test
  e2e/                  End to end tests
  karma.conf.js         Karma setup file
  unit/                 Unit tests
./build/
  index.html            Result of index.jade compilation
  package.json          json file containing setup for the node-webkit executable
  js/
    app.js              The application
    app.tlp.js          AngularJS preloaded templateCache
  static/               All staticic files
    images/             All images
    vendor/             3rd party scripts and files  - NOTICE: see bower dependency inclusion
      ...               vendor specific folders
  styles                Home of .less compilation
```

## Bower Dependency Inclusion
Bower Dependency Inclusion `BDI` - Includes dependent libraries defined in the `dependiencies` part of `./bower.json` and only if they define `"main": "some.file.ext"`

`./bower_components/angular/bower.json` looks like this
```json
{
  "name": "angular",
  "version": "1.2.16",
  "main": "./angular.js",
  "dependencies": {
  }
}
```
This is used to include javascript, less and any other dependency types.
If you all other types then `js` and `less` you will need to define a new gulp task which uses `bowerDependencyInclusion` to retrieve an array of relative to root path strings, `./bower_components/boo/bar/baz.json`

Since some scripts can be dependent on each other i.e. angular uses jquery lite unless you include jQuery first. To achive this BDI can be called with an array of items to include before any other. Beyond that scripts are included in natural order.

```coffeescript
gulp.task 'some task', ->
  gulp.src bdi([
      './bower_components/jquery/dist/jquery.js'
      './bower_components/angular/angular.js'
      paths.dev.vendor.src + '/**/*.js'
      ], '.js')
  ...
```

Take a look at `./scripts/bowerDependencyInclusion.coffee` for implementation.

## Commandline
While gulp is the primary build system some tasks are not yet avaliable using gulp thus a few items are grunt "powered"

# TODO
* bowerDependencyInclusion
    * Move this into its own github repository as an npm module or find replacement
    * Make sure this is windows compatible
* npm automatically install dependencies
* Make sure gulpfile.js is windows compatible
* Dependency & Installation
    * Add instruction for installing node-webkit and adding it to path