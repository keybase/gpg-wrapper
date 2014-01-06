{spawn} = require 'child_process'
stream = require './stream'
{E} = require './err'
{parse} = require('pgp-utils').userid

##=======================================================================

_log = (x) -> console.warn x.toString('utf8')
exports.set_log = set_log = (log) -> _log = log

##=======================================================================

exports.Engine = class Engine

  constructor : ({@args, @stdin, @stdout, @stderr, @name}) ->

    @name or= "gpg"

    @stderr or= new stream.FnOutStream(_log)
    @stdin or= new stream.NullInStream()
    @stdout or= new stream.NullOutStream()

    @_exit_code = null
    @_exit_cb = null
    @_n_out = 0

  run : () ->
    @proc = spawn @name, @args
    @stdin.pipe @proc.stdin
    @proc.stdout.pipe @stdout
    @proc.stderr.pipe @stderr
    @pid = @proc.pid
    @_n_out = 3 # we need 3 exit events before we can exit
    @proc.on 'exit', (status) => @_got_exit status
    @proc.stdout.on 'end', () => @_maybe_finish()
    @proc.stderr.on 'end', () => @_maybe_finish()
    @

  _got_exit : (status) ->
    @_exit_code = status
    @proc = null
    @_maybe_finish()

  _maybe_finish : () ->
    if --@_n_out <= 0
      if (ecb = @_exit_cb)?
        @_exit_cb = null
        ecb @_exit_code
      @pid = -1

  wait : (cb) ->
    if (@_exit_code and @_n_out <= 0) then cb @_exit_code
    else @_exit_cb = cb

##=======================================================================

bufferify = (x) ->
  if not x? then null
  else if (typeof x is 'string') then new Buffer x, 'utf8'
  else if (Buffer.isBuffer x) then x
  else null

##=======================================================================

# This is a little hack to universally deal with temporary keyrings,
# if that's what's needed.
_args_mutate  = null
exports.set_args_mutate = (am) -> _args_mutate = am

##=======================================================================

exports.gpg = gpg = (inargs, cb) ->
  
  inargs = _args_mutate(inargs) if _args_mutate?
  {args, stdin, stdout, stderr, quiet} = inargs

  if (b = bufferify stdin)?
    stdin = new stream.BufferInStream b
  if quiet
    stderr = new stream.NullOutStream()
  if not stdout?
    def_out = true
    stdout = new stream.BufferOutStream()
  else
    def_out = false
  err = null
  await (new Engine { args, stdin, stdout, stderr }).run().wait defer rc
  if rc isnt 0
    err = new E.GpgError "exit code #{rc}"
    err.rc = rc
  out = if def_out? then stdout.data() else null
  cb err, out

##=======================================================================

exports.assert_no_collision = assert_no_collision = (short_id, cb) ->
  args = [ "-k", short_id ]
  await gpg { args, quiet : true } , defer err, out
  if not err? and (n = (stream.grep { pattern : "/#{short_id}", buffer : out }).length) > 1
    err = new E.PgpIdCollisionError "Found two keys for ID=#{short_id}"
  cb err, n

##=======================================================================

exports.assert_exactly_one = (short_id, cb) ->
  await assert_no_collision short_id, defer err, n
  err = new E.NotFoundError "Didn't find a key for #{short_id}" unless n is 1
  cb err

##=======================================================================

exports.read_uids_from_key = ({fingerprint}, cb) ->
  args = [ "-k", fingerprint ]
  await gpg { args, quiet : true } , defer err, out
  unless err?
    pattern = /^uid\s+(.*)$/
    lines = stream.grep { buffer : out, pattern }
    out = (u for line in lines when (m = line.match pattern)? and (u = parse m[1])?)
  cb err, out

##=======================================================================
