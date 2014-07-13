// Generated by CoffeeScript 1.7.1

/*
Findes all files in bower.json ending in extensionType
 * TODO: Add curried versions allowing one to add devDeps
bdi('.js', before, after, devDeps = true)
bdi('.js', before, devDeps = true)
bdi('.js', devDeps = true)
bdi('.js')
 */
module.exports = function(extensionType) {
  var bowerComponentDirs, bowerDeps, bower_components, dir, fileNames, fs, gutil, path, sources, _, _i, _len;
  gutil = require('gulp-util');
  _ = require('underscore');
  fs = require('fs');
  path = require('path');
  bower_components = './bower_components';
  fileNames = fs.readdirSync(bower_components);
  sources = [];
  bowerDeps = [];

  /*
  parse main bower.json for dependencies, ignore devDeps
   */
  (function() {
    var deps, fileContent, jsonData, k, v;
    fileContent = fs.readFileSync('./bower.json', 'utf8');
    jsonData = JSON.parse(fileContent);
    deps = jsonData['dependencies'];
    for (k in deps) {
      v = deps[k];
      bowerDeps.push(k);
    }
  })();

  /*
  Iterates folders in bower_components
   */
  bowerComponentDirs = function(dir) {
    var content, file, inBower_comp, parseMain, parseMainTypeFiles, push, _i, _len;
    inBower_comp = bower_components + '/' + dir;
    if (fs.statSync(inBower_comp).isDirectory() && bowerDeps.indexOf(dir) > -1) {
      content = fs.readdirSync(inBower_comp);
      push = function(file) {
        var fullPath;
        fullPath = inBower_comp + '/' + file;

        /* Makes sure that if filePath was given in before it is not added */
        if (sources.indexOf(fullPath) < 0) {
          return sources.push(fullPath);
        }
      };

      /*
      Extracts main attribute, if it exists and the file extension matches
      adds it to sources with path relative to parent folder of gulpfile.js
       */
      parseMainTypeFiles = function(bowerKey, bowerVal) {
        var m, matcher;
        if (bowerKey === 'main') {

          /* TODO implement checks for array, if array add all, otherwise if string just add it */

          /* Matches files ending in type given in extensionType */
          matcher = new RegExp(extensionType + '$');
          if (matcher.test(bowerVal)) {
            m = new RegExp('^\\.\\/');
            if (m.test(bowerVal)) {
              return push(bowerVal.substring(2));
            } else {
              return push(bowerVal);
            }
          }
        }
      };

      /*
      Finds bower.json files
       */
      parseMain = function(file) {
        var data;
        if (fs.statSync(file).isFile()) {
          if (path.basename(file) === 'bower.json') {
            data = fs.readFileSync(file, 'utf8');
            return JSON.parse(data, parseMainTypeFiles);
          }
        }
      };
      for (_i = 0, _len = content.length; _i < _len; _i++) {
        file = content[_i];
        parseMain(inBower_comp + '/' + file);
      }
    }
  };
  for (_i = 0, _len = fileNames.length; _i < _len; _i++) {
    dir = fileNames[_i];
    bowerComponentDirs(dir);
  }
  return sources;
};
