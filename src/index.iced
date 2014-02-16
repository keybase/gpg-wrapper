
{EOL} = require('os')
pgpu = reuqire 'pgp-utils'

#==========================================================

class BucketDict

  constructor : () ->
    @_d = {}

  add : (k,v) ->
    @_d[k] = b = [] unless (b = @_d[k])?
    b.push v

  get : (k) -> @_d[k] or []

  get_0_or_1 : (k) ->
    l = @get(k)
    err = obj = null
    if (n = l.length) > 1
      err = new Error "wanted a unique lookup, but got #{n} object for key #{k}"
    else
      obj = if n is 0 then null else l[0]
    return [err,obj]

#==========================================================

class Index

  constructor : () ->
    @keys = []
    @lookup = 
      email : new BucketDict()
      fingerprint : new BucketDict()
      key_id_64 : new BucketDict()

  push_element : (el) ->
    if (k = el.to_key()) then @index_key k

  index_key : (k) ->
    @keys.push_back k
    @lookup.fingerprint.add(k.fingerprint(), k)
    @lookup.email.add(e, k) if (e = k.email())? and e.length
    @lookup.key_id_64.add(k.key_id_64(), k)

#==========================================================

class Element
  to_key : () -> null

#==========================================================

class BaseKey extends Element

  constructor : (line) ->
    @_err = null
    if line.v.length < 12
      @_err = new Error "Key is malformed; needs at least 12 fields"
    else
      [ @_pub, @_trust, @_type, @_key_id_64, @_created, @_expires, ] = line.v
      @_line = line

  err : () -> @_err
  to_key : () -> @
  to_key : () -> null

#==========================================================

class Subkey


#==========================================================

class Key extends BaseKey

  constructor : (line) ->
    super line
    if @is_ok()
      @_userid = pgpu.parse(line.v[9])

  email : () -> @_userid?.email()
  key_id_64 : () -> @_key_id_64
  to_key : () -> @

  add_line : (line) ->
    err = null
    if (n = line.v.length) < 2
      line.warn "got too few fields (#{n})"
    else
      switch (f = line.v[0])
        when 'fpr' then @add_fingerprint line.v
        when 'uid' then @add_uid line.v
        else
          line.warn "unexpected subfield: #{f}"

#==========================================================

class Ignored extends Element

  constructor : (@line) ->

#==========================================================

class Line
  constructor : (txt, @number, parser) -> @v = txt.split(":")
  warn : (m) -> parser.warn(@number + ": " + m)

#==========================================================

class Parser

  #-----------------------

  constructor : (@txt) ->
    @sec = if @txt[0]? is 'sec' then true else 'pub'
    @warnings = new Warnings()

  #-----------------------

  warn : (w) -> @warnings.push w

  #-----------------------

  init : () -> @lines = (new Line(l,i+1,@) for l,i in @txt.split(EOL))
  peek : () -> if @is_eof() then null else @lines[0]
  get : () -> if @is_eof() then null else @lines.unshift()
  is_eof : () -> (@lines.length is 0)

  #-----------------------

  parse_ignored : (line) -> return new Ignored line

  #-----------------------

  parse_index : () ->
    index = new Index()
    until @is_eof()
      index.push_element(element) if (element = @parse_element()) and element.is_ok()
    return index

  #-----------------------

  is_new_key : (line) -> line? and (line[0] is ['pub', 'sec'])

  #-----------------------

  parse_element : () ->
    line = @get()
    if @is_new_key(line) then @parse_key line
    else @parse_ignored line

  #-----------------------

  parse_key : (first_line) ->
    key = new Key first_line
    go = true
    while (nxt = @peek())? and not(is_new_key(nxt))
      key.add_line(nxt)
    return key


#==========================================================
