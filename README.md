IMPORTANT: this is still under development, any request may be filled and pleeeease if you find some errors, or you know some better way to do stuff. Send a mail, raise an issue or do a pull request

<!-- [TOC] -->
<div class="toc">
<ul>
<li><a href="#yet-another-node-webkit-seed">Yet another node-webkit seed</a><ul>
<li><a href="#dependencies-installation">Dependencies &amp; Installation</a><ul>
<li><a href="#0-prerequisites">0 Prerequisites</a></li>
<li><a href="#1-clone-git">1 Clone git</a></li>
<li><a href="#2-download-missing-dependencies">2 Download missing dependencies</a></li>
<li><a href="#3-initial-build">3 Initial build</a></li>
</ul>
</li>
<li><a href="#technologies-in-use">Technologies in use</a></li>
<li><a href="#node-webkit">Node-webkit</a></li>
<li><a href="#directory-structure">Directory structure</a></li>
<li><a href="#bower-dependency-inclusion">Bower Dependency Inclusion</a></li>
<li><a href="#commandline">Commandline</a></li>
</ul>
</li>
<li><a href="#credits">Credits</a></li>
<li><a href="#todo">TODO</a></li>
</ul>
</div>

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
    * UglifyJS - no enabled yet - need to add gulp-if to build
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

# Credits
Thanks to Anonyfox, the man behind [node-webkit-hipster-seed](https://github.com/Anonyfox/node-webkit-hipster-seed) from where I have nicked parts of this readme

# TODO
* bowerDependencyInclusion
    * Move this into its own github repository as an npm module or find replacement
    * Make sure this is windows compatible
* npm automatically install dependencies
* Make sure gulpfile.js is windows compatible
* Dependency & Installation
    * Add instruction for installing node-webkit and adding it to path
* Gulp build
    * Add gulp-if and use this it controle uglification of js in production
    * Research and findout how to use `gulp-util` for above
* Maybe use [yeoman.io](http://yeoman.io/) to write a generator