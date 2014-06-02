// Generated by CoffeeScript 1.7.1

/*
Findes all files in bower.json ending in extensionType
 */
module.exports = function(before, extensionType) {
  var bowerComponentDirs, bower_components, dependentJS, dir, fileNames, fs, gutil, path, readMainBowerFile, sources, _i, _len;
  gutil = require('gulp-util');
  bower_components = './bower_components';
  if (Object.prototype.toString.call(before) !== '[object Array]') {
    gutil.log('before was not an array!');
  }
  fs = require('fs');
  path = require('path');
  fileNames = fs.readdirSync(bower_components);
  sources = before;
  dependentJS = [];

  /*
  parse main bower.json for dependencies, ignore devDeps
   */
  readMainBowerFile = function() {
    var deps, fileContent, jsonData, k, v, _results;
    fileContent = fs.readFileSync('./bower.json', 'utf8');
    jsonData = JSON.parse(fileContent);
    deps = jsonData['dependencies'];
    _results = [];
    for (k in deps) {
      v = deps[k];
      _results.push(dependentJS.push(k));
    }
    return _results;
  };
  readMainBowerFile();

  /*
  Iterates folders in bower_components
   */
  bowerComponentDirs = function(dir) {
    var content, file, inBower_comp, parseMain, parseMainTypeFiles, push, _i, _len;
    inBower_comp = bower_components + '/' + dir;
    if (fs.statSync(inBower_comp).isDirectory() && dependentJS.indexOf(dir) > -1) {
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