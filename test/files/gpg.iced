
{colgrep,GPG} = require '../../lib/main'

exports.test_assert_no_collision = (T,cb) ->
  obj = new GPG()
  await obj.run { args : [ "-k", "--with-colons" ] }, defer err, out
  T.no_error err
  out = colgrep {
    patterns : {
      0 : /[ps]ub/ 
    },
    buffer : out,
    separator : /:/
  }
  T.assert (out.length > 0), "need at least 1 key to make this work"
  key = out[0][4]
  await obj.assert_no_collision key, defer err, n
  T.no_error err
  T.equal n, 1, "we found exactly 1 key"
  cb()