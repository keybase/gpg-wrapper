
{spawn} = require 'child_process'
stream = require './stream'
{E} = require './err'
{parse} = require('pgp-utils').userid
cmd = require './cmd'

##=======================================================================

exports.GPG = class GPG

  CMD : "gpg"

  #----

  constructor : () ->

  #----

  mutate_args : (args) -> 

  #----

  run : (inargs, cb) -> 
    @mutate_args inargs
    env = process.env
    delete env.LANGUAGE
    inargs.name = @CMD
    inargs.eklass = { cmd : E.GpgError }
    inargs.opts = { env }
    await cmd.run inargs, defer err, out
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
      rows = stream.colgrep {
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
      rows = stream.colgrep {
        patterns : { 0 : /^uid|pub$/ },
        buffer : out,
        separator : /:/
      } 
      uids = (parse(col) for row in rows when ((col = row[9])? and col.length > 0))
    cb err, uids

##=======================================================================

