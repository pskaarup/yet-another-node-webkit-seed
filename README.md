IMPORTANT: this is still under development, any request may be filled and pleeeease if you find some errors, or you know some better way to do stuff. Send a mail, raise an issue or do a pull request

[TOC]

----
# Yet another node-webkit seed
`yet-another-node-webkit-seed` is a skeleton for development of multiplayform Desktop Applications through the use of [node-webkit](https://github.com/rogerwang/node-webkit) as a `node` and `webkit` runtime environment for ECMAscript and html based applications

## Dependencies & Installation
The skeleton has a few dependencies including those found in `bower.json` and `package.json`

### 0 Prerequisites
You need the following stuff installed on your machine:

* [Node.js & NPM](http://nodejs.org/) (see the instructions for your operating system. Ensure that globally installed NPM modules are in your PATH!)

* Windows Users: Use a Git Bash or the [PowerShell](http://en.wikipedia.org/wiki/Windows_PowerShell) instead of CMD.exe !

* Linux Users: You may have to do a [symlink](https://github.com/rogerwang/node-webkit/wiki/The-solution-of-lacking-libudev.so.0). 

* Git. (Bower depend on Git to work.) Windows users: try [this](http://git-scm.com/), there is a good usable CLI included which should work with the workflow out-of-the-box. The primitive CMD.exe is currently NOT supported.
* Mac users may need to use `sudo` for following commands

    * [gulp](http://gulpjs.com/) via a global npm installation: `npm install -g gulp`.

    * [Bower](http://bower.io/) via a global npm installation: `npm install -g bower`.

* Download [node-webkit](https://github.com/rogerwang/node-webkit#downloads) prebuilt binaries to a directory of your choice (outside . directory) and include in `$PATH`

    For mac: `export PATH=~/path/to/node-webkit/0.9.2/node-webkit.app/Contents/MacOS:$PATH`

    For windows: TODO, someone help me :)

    Note the version number as we are using `grunt-node-webkit-builder` and both need to use the same version to avoid versioning issues. In `Gruntfile.coffee` under `nodewebkit:` where it specifies the `version:`

    The reason you need this is that [nodewebkit](https://www.npmjs.org/package/nodewebkit) npm package for some reason only lets you download version 0.8.6.
    That version has a lot of bugs on macs and is... well old. And if you force install the 0.9.2 you get a corrupt download. Once a new version is released I'll update this.

### 1 Clone git
`git clone https://github.com/pskaarup/yet-another-node-webkit-seed.git [Directory name of your choice]` or if you prefer it without a git repository [download the zip](https://github.com/pskaarup/yet-another-node-webkit-seed/archive/master.zip)

### 2 Download missing dependencies
`npm install` and `bower install`

### 3 Initial build
The final step of the setup run `gulp all` which will run all `gulp` tasks and produce runnable code of the skeleton

## Technologies in use
* Frontend
    * [AngularJS](angularjs.org)
    * Generate template caches using $templateCache TODO implement is feature or find plugin
    * [CoffeeScript](coffeescript.org)
    * UglifyJS
    * CSS using [LESS](lesscss.org)
* Backend - backend of compiled applications
    * [Nedb](https://github.com/louischatriot/nedb)
* Testing - Units and e2e
    * Karma
    * Jasmin
    * Protractor
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
        controllers
        ...
        services
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
    app.tlp.js          AngularJS preloaded templateCache - NOTICE: NOT WORKING YET!
  static/               All staticic files
    images/             All images
    vendor/             3rd party scripts and files  - NOTICE: see bower dependency inclusion
      ...               vendor specific folders
  styles                Home of .less compilation
```

## Commandline
While gulp is the primary build system some tasks are not yet avaliable using gulp thus a few items are grunt "powered"

* `gulp clean` - delets all files in the build directory
* `gulp all` - "compiles" all parts of the source in `src`
    * To compile for production, use `NODE_ENV=production gulp all`

        Production disables sourcemaps and enables uglifyJS

* `gulp watch` - depends on `gulp all` which it runs first, then it watches all files in `src` for changes and compiles accordingly.

* `grunt` runs the default grunt task, which is `grunt nodewebkit`    

    This task downloads node-webkit bins if not present and creates the executables.

    You can define which binaries to download and which operating systems to create executables for in `Gruntfile.coffee` under `nodewebkit.options`

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

## Sourcemap limitations
Current not implemented for the following reasons.

Primarily i'm a dipstick, i can't get the bloddy things to work as they should. The maps generated by `gulp-coffee` works in firefox but not in chrome o.0. Don't really know why this is the case. 

Secondly i wan't the development workflow to have sourcemaps and ideally have all `.coffee` files translated into a single `.js` file. This however poses a few problems. `gulp-coffee` can either generate inline sourcemaps which i never got to work or generate a separate `.map` file. This still needs the original `.coffee` file, which i could just copy to the `build` folder. BUT when trying to concatenate the files together these sourcemaps are inlined in the resulting `.js` file, which needless to say is illegal js syntax.

Thus for sourcemaps to work i need to figure out how to have sourcemaps for all sourcefiles in the same concatenated `.js` file. Untill i have solved this issue the development workflow will be as stated in the development workflow section.

# Development workflow
This section will cover how I intent development using this buildsystem and skeleton should be done. Since the current skeleton has a few limitations regarding sourcemaps a few workarounds has been put in place.

## Environments
Using `NODE_ENV` you can declare which environment to compile to. `$ NODE_ENV=production gulp <command>` will result in production compilation. Ommited development is assumed.

## Sourcemap workarounds
The section `Sourcemap limitations` (TODO: fix references) cover the reasons behind this.

To enable sourcemaps in development each `.coffee` file is compile to its matching `.js` file in `build/app/js/` including whichever folder it's in. The result of this is that the application `index.jade` needs to reflect this.

`index.jade`:
```jade
// build:js
script(src="app/js/app.js")
script(src="app/js/controllers/MyCtrl1.js")
script(src="app/js/directives/directives.js")
script(src="app/js/filters/filters.js")
script(src="app/js/services/services.js")
// endbuild
```

`// build:js` tells the buildsystem which scripts should be concatenated in production mode while left as is in development. This will ease development as each `.coffee` has its own `.js` as previously stated. Without the assistance of sourcemaps this is verymuch required.

The result of this requirement is that whenever you add a `coffee` file to source you need to add it in the above section. The build system will then compile it using the same directory in `build/app/js`.
To make it clear `src/app/coffee/app.coffee` will be compile to `build/app/js/app.js`.

## bower dependencies
Dependencies declared in `bower.json` under `dependencies` will automatically be concatenated into `build/app/static/vendor.js`.
When compiling to production this will be minified

## Unit and end to end testing
While the skeleton has these in included there is currently a big problem. Node-webkit allows you to call the file system from "client side" js, which in browsers like chrome etc is impossible thus one should either program front end as an actual front end talking to backend through some rest interface.. a mess, we don't want this.

It is possible, just needs som work!

[https://github.com/varunvairavan/node-webkit-unit-testing](https://github.com/varunvairavan/node-webkit-unit-testing)

[https://github.com/rogerwang/node-webkit/wiki/chromedriver](https://github.com/rogerwang/node-webkit/wiki/chromedriver)

[https://github.com/intelligentgolf/karma-nodewebkit-launcher](https://github.com/intelligentgolf/karma-nodewebkit-launcher)

# Credits
Thanks to Anonyfox, the man behind [node-webkit-hipster-seed](https://github.com/Anonyfox/node-webkit-hipster-seed) from where I have nicked parts of this readme

# TODO
* bowerDependencyInclusion
    * Move this into its own github repository as an npm module or find replacement
    * Make sure this is windows compatible
* Make sure gulpfile.js is windows compatible
* Maybe use [yeoman.io](http://yeoman.io/) to write a generator
* Setup testing part of skeleton
    *  write an example test
    *  Protractor - TODO Find plugin for chromium execution, or use phantomJS
* VERY IMPORTANT: Figure out how to concat `coffee/**/*.coffee` with sourcemaps into a single file!
    
    This is to allow for a file for each directive, filter, etc. This will make the code more readable

    Alternatively in development node automatically include all scripts in `coffee/**` as separate script tags - we are doing this now.

    DEAL BREAKER!: can't get sourcemaps to work so i have implemented it this way.

    under development each `.coffee` file needs to be added to index.jade with `.js` replacing `.coffee` see skeleton app for details
* Bower dependent vendor files should not be compiled to `.../static/vendor/vendor.js` but `.../static/vendor.js`

* Create github wiki as the size of this readme is getting a bit too large

* Add task for updating `app/package.json`