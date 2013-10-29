// Generated by CoffeeScript 1.6.3
var outcome, stepc, vine;

outcome = require("outcome");

stepc = require("stepc");

vine = require("vine");

exports.require = ["http.server", "npm.search"];

exports.load = function(httpServer, npmSearch) {
  /*
  
    /api/plugins/stats.json
    /api/plugins?q=search
  */

  return httpServer.get("/api/plugins.json", function(req, res) {
    var kw, o, q;
    kw = new RegExp(req.query.q);
    q = {
      keywords: {
        $in: ["mojo-plugin"]
      },
      $or: [
        {
          keywords: kw
        }, {
          name: kw
        }
      ]
    };
    console.log(JSON.stringify(q, null, 2));
    o = outcome.e(function(err) {
      return res.send(vine.error(err));
    });
    return stepc.async(function() {
      return npmSearch.search(q, this);
    }, o.s(function(items) {
      return res.send(vine.result(items));
    }));
  });
};