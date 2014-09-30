path = require "path"
superagent = require "superagent"
async = require "async"
detective = require "detective"
paperclip = require "paperclip"
require "paperclip/lib/parser"

parser = window?.paperclip.template.compiler


exports.compile = (files, complete) ->
  addLocalDeps files
  addRemoteFiles files, (err) ->
    if err
      return complete err
    try 
      complete null, compile files
    catch e
      complete e


addLocalDeps = (files) ->
  files.forEach (file) ->
    file.deps = detective file.content


scanRemoteDeps = (files) ->
  remoteDeps = []

cdn = "http://browserify-cdn.herokuapp.com"
cdn = "http://wzrd.in"

addRemoteFiles = (files, complete) ->
  remoteDeps = {}

  for file in files
    for dep in file.deps
      unless ~dep.indexOf("/")
        depParts = dep.split("@")
        remoteDeps[depParts.shift()] = depParts.shift() || "latest"

  pkg = {
    "options": {
      "debug": true
    },
    "dependencies": remoteDeps
  }

  unless Object.keys(remoteDeps).length
    return complete()

  superagent.post(cdn + "/multi").send(pkg).end (err, response) ->

    if err
      return complete err

    unless response.body
      return complete new Error response.text
    

    console.log response.body
    for moduleName of response.body
      files.push {
        path: if remoteDeps[moduleName] is "latest" then moduleName else moduleName + "@" + remoteDeps[moduleName],
        content: "module.exports = " + response.body[moduleName].bundle + "('"+moduleName+"')"
      }

    complete()


  async.each remoteDeps


compile = (files) ->

  buffer = "
    (function () {\n

    var defined = {},
    modules     = {};

    function define (path, createModule) {
      defined[path] = createModule;
    }

    function resolve (path) {
      if (defined[path]) return path;
      if (defined[path + '/index.js']) return path + '/index.js';
      if (defined[path + '.js']) return path + '.js';
    }

    function require (path) {
      var resolvedPath = resolve(path);
      if (!resolvedPath) {
        throw new Error('unable to resolve ' + path);
      }
      return modules[resolvedPath] || (modules[resolvedPath] = createModule(resolvedPath))
    }

    function createModule (path) {

      var module = {
        exports: {}
      };

      var pathParts = path.split('/'),
      dirname       = pathParts.slice(0, pathParts.length - 1).join('/');

      defined[path](module, module.exports, function (relpath) {
        return require(relpath.replace(/^\\./, dirname));
      });

      return module.exports;
    }
  "

  for file in files
    buffer += "\ndefine('"+file.path+"', function (module, exports, require) {"
    buffer += "\n" + transformContent(file) + "\n";
    buffer += "});"

  
  buffer += "return require('/index.js');";
  buffer += "\n})();"

  return new Function("return " + buffer)()


transformContent = (file) ->


  if (ext = file.path.split(".").pop()) is "pc"
    return parser.parse file.content
  else if ext is "js" or !~file.path.indexOf(".") or ~file.path.indexOf("@")
    return file.content
  else
    return "module.exports = decodeURIComponent('" + encodeURIComponent(file.content) + "');"

