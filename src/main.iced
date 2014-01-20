modules = [
  require("./cmd")
  require("./err")
  require("./gpg")
  require("./parse")
  require("./stream")
]
for m in modules
  for k,v of m
    exports[k] = v

# Export keyring stuff in a namespace
exports.keyring = require('./keyring')
