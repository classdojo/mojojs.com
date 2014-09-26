ClassDojoApplication = require "../common/application"
require "./logger"

###
###

class ClassDojoServerApplication extends ClassDojoApplication

  ###
  ###

  plugins: [
    require("mojo-router"),
    require("./server"),
    require("./routes"),
    require("./models"),
    require("./views")
  ]


module.exports = ClassDojoServerApplication