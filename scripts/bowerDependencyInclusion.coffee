###
Findes all files in bower.json ending in extensionType
TODO add after optional array
###
module.exports = (before, extensionType) ->
  gutil = require 'gulp-util'
  bower_components = './bower_components'
  if Object.prototype.toString.call( before ) != '[object Array]'
    gutil.log 'before was not an array!'

  fs = require 'fs'
  path = require 'path'
  fileNames = fs.readdirSync bower_components
  sources = before

  dependentJS = []

  ###
  parse main bower.json for dependencies, ignore devDeps
  ###
  readMainBowerFile = () ->
    fileContent = fs.readFileSync './bower.json', 'utf8'
    jsonData = JSON.parse fileContent
    deps = jsonData['dependencies']
    dependentJS.push k for k, v of deps
  readMainBowerFile()

  ###
  Iterates folders in bower_components
  ###
  bowerComponentDirs = (dir) ->
    inBower_comp = bower_components + '/' + dir
    # if dir isDirectory and is a non dev dependencie
    if fs.statSync(inBower_comp).isDirectory() && dependentJS.indexOf(dir) > -1
      content = fs.readdirSync inBower_comp

      push = (file) ->
        fullPath = inBower_comp + '/' + file
        ### Makes sure that if filePath was given in before it is not added ###
        if sources.indexOf(fullPath) < 0
          sources.push fullPath

      ###
      Extracts main attribute, if it exists and the file extension matches
      adds it to sources with path relative to parent folder of gulpfile.js
      ###
      parseMainTypeFiles = (bowerKey, bowerVal) ->
        if bowerKey == 'main'
          ### Matches files ending in type given in extensionType ###
          matcher = new RegExp extensionType + '$'
          if matcher.test bowerVal
            # Remove possible './'
            m = new RegExp '^\\.\\/'
            if m.test bowerVal
              push bowerVal.substring(2)
            else
              push bowerVal

      ###
      Finds bower.json files
      ###
      parseMain = (file) ->
        if fs.statSync(file).isFile()
          if path.basename(file) == 'bower.json'
            data = fs.readFileSync file, 'utf8'
            JSON.parse data, parseMainTypeFiles
      (parseMain inBower_comp+'/'+file for file in content)
      return
  (bowerComponentDirs dir for dir in fileNames)
  sources