views = require "mojo-views"

class Preview extends views.Base
  paper: require("./index.pc")
  define: ["content"]
  bindings:
    "script": (script) ->
      unless script
        return
      try 
        div = document.createElement "div"          
        script div
        @set "content", div
        console.log div
      catch e
        console.error e


module.exports = Preview