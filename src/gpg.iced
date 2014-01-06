
{spawn} = require 'child_process'
stream = require './stream'
{E} = require './err'
{parse} = require('pgp-utils').userid
cmd = require './cmd'

##=======================================================================

exports.GPG = class GPG

  #----

  constructor : () ->

  #----

  mutate_args : (args) -> args

  #----

  run : (inargs, cb) -> 
    inargs.args = @mutate_args inargs.args
    inargs.name = "gpg"
    inargs.eklass = E.GpgError
    await cmd.run inargs, defer err, out
    cb err, out

  #----

  assert_no_collision : (short_id, cb) ->
    args = [ "-k", short_id ]
    await @run { args, quiet : true } , defer err, out
    if not err? and (n = (stream.grep { pattern : "/#{short_id}", buffer : out }).length) > 1
      err = new E.PgpIdCollisionError "Found two keys for ID=#{short_id}"
    cb err, n

  #----

  assert_exactly_one : (short_id, cb) ->
    await @assert_no_collision short_id, defer err, n
    err = new E.NotFoundError "Didn't find a key for #{short_id}" unless n is 1
    cb err

  #----

  read_uids_from_key : ({fingerprint}, cb) ->
    args = [ "-k", fingerprint ]
    await @run { args, quiet : true } , defer err, out
    unless err?
      pattern = /^uid\s+(.*)$/
      lines = stream.grep { buffer : out, pattern }
      out = (u for line in lines when (m = line.match pattern)? and (u = parse m[1])?)
    cb err, out

##=======================================================================
