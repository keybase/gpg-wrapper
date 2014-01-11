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

