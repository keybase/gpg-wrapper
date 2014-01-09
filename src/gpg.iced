
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

  mutate_args : (args) -> 

  #----

  run : (inargs, cb) -> 
    @mutate_args inargs
    inargs.name = "gpg"
    inargs.eklass = E.GpgError
    await cmd.run inargs, defer err, out
    cb err, out

  #----

  assert_no_collision : (id, cb) ->
    args = [ "-k", "--with-colons", id ]
    n = 0
    await @run { args, quiet : true } , defer err, out
    if err? then # noop
    else
      cols = stream.colgrep {
        patterns : {
          0 : /^[sp]ub$/
          4 : (new RegExp "^.*#{id}$", "i")
        },
        buffer : out,
        separator : /:/
      }
      if (n = cols.length) > 1
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
