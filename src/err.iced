
ie = require 'iced-error'

#================================================

exports.E = ie.make_errors
  GPG : "Command line error"
  PGP_ID_COLLISION : "PGP ID collision error"
  NOT_FOUND : "Key wasn't found"
