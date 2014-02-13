
{run} = require '../../lib/cmd'
{E} = require '../../lib/err'

exports.not_found = (T,cb) ->
  inargs = 
    args : []
    name : "no_way_jose"
  await run inargs, defer err, out
  T.assert err?, "Error was produced"
  T.assert (err instanceof E.CmdNotFoundError), "got the right error class"
  cb()

