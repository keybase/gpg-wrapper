{spawn} = require 'child_process'
stream = require './stream'
{E} = require './err'
{parse} = require('pgp-utils').userid
{make_esc} = require 'iced-error'

##=======================================================================

_log = (x) -> console.warn x.toString('utf8')
exports.set_log = set_log = (log) -> _log = log

##=======================================================================

exports.Engine = class Engine

  #--------

  constructor : ({@args, @stdin, @stdout, @stderr, @name, @opts}) ->

    @stderr or= new stream.FnOutStream(_log)
    @stdin or= new stream.NullInStream()
    @stdout or= new stream.NullOutStream()
    @opts or= {}

    @_exit_code = null
    @_exit_cb = null
    @_n_out = 0

  #--------

  _spawn : ({eklass}, cb) ->
    err = null
    try
      @proc = spawn @name, @args, @opts
    catch e
      klass = eklass?.cmd_not_found or E.CmdNotFoundError
      err = new klass "Failed to spawn #{@name}: #{e.message}"
    cb err

  #--------

  run : ({eklass}, cb) ->
    esc = make_esc cb, "Engine::run"
    await @_spawn {eklass}, esc defer()
    @stdin.pipe @proc.stdin
    @proc.stdout.pipe @stdout
    @proc.stderr.pipe @stderr
    @pid = @proc.pid
    @_n_out = 3 # we need 3 exit events before we can exit
    @proc.on 'exit', (status) => @_got_exit status
    @proc.stdout.on 'end', () => @_maybe_finish()
    @proc.stderr.on 'end', () => @_maybe_finish()
    cb null

  #--------

  _got_exit : (status) ->
    @_exit_code = status
    @proc = null
    @_maybe_finish()

  #--------

  _maybe_finish : () ->
    if --@_n_out <= 0
      if (ecb = @_exit_cb)?
        @_exit_cb = null
        ecb @_exit_code
      @pid = -1

  #--------

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

#
# @param {Object} eklass the error classes to use for various failures of the
#     the client
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
  eng = new Engine { args, stdin, stdout, stderr, name }
  await eng.run { eklass }, defer err
  unless err?
    await eng.wait defer rc
    if rc isnt 0
      klass = eklass?.cmd or E.CmdError
      err = new klass "exit code #{rc}"
      err.rc = rc
  out = if def_out? then stdout.data() else null
  cb err, out

##=======================================================================
