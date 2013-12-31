modules = [
  require("./err")
  require("./gpg")
  require("./stream")
]
for m in modules
  for k,v of m
    exports[k] = v

