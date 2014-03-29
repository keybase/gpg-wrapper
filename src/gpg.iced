
{colgrep} = require './colgrep'
{E} = require './err'
{parse} = require('pgp-utils').userid
ispawn = require 'iced-spawn'

##=======================================================================

_gpg_cmd = "gpg"
exports.set_gpg_cmd = (c) -> _gpg_cmd = c
exports.get_gpg_cmd = ( ) -> _gpg_cmd

# A default log for uncaught stderr
_log = null
exports.set_log = (l) -> _log = l

##=======================================================================

exports.GPG = class GPG

  #----

  constructor : (opts) ->
    @CMD = if (c = opts?.cmd)? then c else _gpg_cmd

  #----

  mutate_args : (args) -> 

  #----

  test : (cb) ->
    await ispawn.run { name : @CMD, args : [ "--version" ], quiet : true }, defer err, out
    cb err, out

  #----

  run : (inargs, cb) -> 
    stderr = null
    @mutate_args inargs
    env = process.env
    delete env.LANGUAGE
    inargs.name = @CMD
    inargs.eklass = E.GpgError
    inargs.opts = { env }
    inargs.log = _log if _log?
    inargs.stderr = stderr = new ispawn.BufferOutStream() if not inargs.stderr? and inargs.quiet
    await ispawn.run inargs, defer err, out
    if err? and stderr?
      err.stderr = stderr.data()
    cb err, out

  #----

  command_line : (inargs) ->
    @mutate_args inargs
    v = [ @CMD ].concat inargs.args
    v.join(" ")

  #----

  assert_no_collision : (id, cb) ->
    args = [ "-k", "--with-colons", id ]
    n = 0
    await @run { args, quiet : true } , defer err, out
    if err? then # noop
    else
      rows = colgrep {
        patterns : {
          0 : /^[sp]ub$/
          4 : (new RegExp "^.*#{id}$", "i")
        },
        buffer : out,
        separator : /:/
      }
      if (n = rows.length) > 1
        err = new E.PgpIdCollisionError "Found two keys for ID=#{short_id}"
    cb err, n

  #----

  assert_exactly_one : (short_id, cb) ->
    await @assert_no_collision short_id, defer err, n
    err = new E.NotFoundError "Didn't find a key for #{short_id}" unless n is 1
    cb err

  #----

  read_uids_from_key : ({fingerprint, query }, cb) ->
    args = [ "-k", "--with-colons" ]
    if fingerprint? then args.push fingerprint
    else if query? then args.push query
    uids = []
    await @run { args, quiet : true } , defer err, out
    unless err?
      rows = colgrep {
        patterns : { 0 : /^uid|pub$/ },
        buffer : out,
        separator : /:/
      } 
      uids = (u for row in rows when ((col = row[9])? and col.length > 0 and (u = parse(col))?))
    cb err, uids

##=======================================================================

