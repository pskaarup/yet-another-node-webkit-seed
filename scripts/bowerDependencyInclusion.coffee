###
Findes all files in bower.json ending in extensionType
# TODO: Add curried versions allowing one to add devDeps
bdi('.js', before, after, devDeps = true)
bdi('.js', before, devDeps = true)
bdi('.js', devDeps = true)
bdi('.js')
###
module.exports = (extensionType) ->
  gutil = require 'gulp-util'
  _ = require 'underscore'
  fs = require 'fs'
  path = require 'path'

  bower_components = './bower_components'
  fileNames = fs.readdirSync bower_components

  sources = []
  bowerDeps = []

  ###
  parse main bower.json for dependencies, ignore devDeps
  ###
  do ->
    fileContent = fs.readFileSync './bower.json', 'utf8'
    jsonData = JSON.parse fileContent
    deps = jsonData['dependencies']
    bowerDeps.push k for k, v of deps
    return

  ###
  Iterates folders in bower_components
  ###
  bowerComponentDirs = (dir) ->
    inBower_comp = bower_components + '/' + dir
    # if dir isDirectory and is a non dev dependencie
    if fs.statSync(inBower_comp).isDirectory() && bowerDeps.indexOf(dir) > -1
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
          ### TODO implement checks for array, if array add all, otherwise if string just add it ###
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