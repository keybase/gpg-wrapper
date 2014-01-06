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

exports.bufferify = bufferify = (x) ->
  if not x? then null
  else if (typeof x is 'string') then new Buffer x, 'utf8'
  else if (Buffer.isBuffer x) then x
  else null

##=======================================================================

exports.run = run = (inargs, cb) ->
  {args, stdin, stdout, stderr, quiet, name, eklass} = inargs

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
  await (new Engine { args, stdin, stdout, stderr, name }).run().wait defer rc
  if rc isnt 0
    eklass or= E.CmdError
    err = new eklass "exit code #{rc}"
    err.rc = rc
  out = if def_out? then stdout.data() else null
  cb err, out

##=======================================================================
