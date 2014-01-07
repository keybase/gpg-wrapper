
{E} = require './err'
{GPG} = require './gpg'
util = require 'util'

#=======================================================================


strip = (x) -> if (m = x.match(/^\s*(.*)$/)) then m[1] else x

class Packet
  constructor : ( {@type, @options } ) -> @_subfields = []
  add_subfield : (f) -> @_subfields.push f

class Message
  constructor : (@packets) ->

#=======================================================================

#
# Parse GPG messages using `gpg --list-packets`
#
exports.Parser = class Parser

  constructor : (@pgp_output) ->

  run : () ->
    @preprocess()
    new Message @parse_packets()

  preprocess : () -> @_lines = (line for line in @pgp_output.split("\n") when line.match /\S/)
  parse_packets : () -> (@parse_packet() until @eof())
  peek : () -> @_lines[0]
  get : () -> @_lines.shift()
  eof : () -> @_lines.length is 0

  parse_packet : () ->
    rxx = /^:([a-zA-Z0-9_ -]+) packet:( (.*))?$/ 
    first = @get()
    unless (m = first.match rxx)
      console.log first
      throw new E.ParseError "expected ':literal data packet:' style header"
    packet = new Packet { type : m[1], options : m[3] }
    until (@eof() or @peek()[0] is ':')
      packet.add_subfield strip(@get())
    return packet

#=======================================================================

exports.parse = parse = ({gpg, packet}, cb) ->
  gpg or= new GPG 
  await gpg.run { args : [ "--list-packets"], stdin : packet }, defer err, buf
  packets = null
  unless err?
    try
      message = (new Parser buf.toString('utf8')).run()
    catch e
      err = e
  cb err, message
      
#=======================================================================

packet = """
-----BEGIN PGP MESSAGE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
Comment: GPGTools - https://gpgtools.org

owEBPALD/ZANAwAKAS/gHEVDSNo5AcsMYgBSzEhJaGVsbG8KiQIcBAABCgAGBQJS
zEhJAAoJEC/gHEVDSNo5d5gQAMHe2bPIFLL8wdu+KG9rkSqZ3iHloaHTkhN729T1
+OefN1YeS7RpOHMcptNKtu36f9LFeDUCfgeevXcL3v3f5Crvl1TCmAft87HlsqZ0
2L++qULRkauu2+HYHB0tr5RwaTYH8A3rYLD79Atrh0XStHcsh3C6ISmePEl+eStE
3uhaEZ+r/PTKxN7/+qh8tGQuhRTI1fC/3rZmDqHQigTJm6pBvy/kDeATVdKevpbZ
brM+1jWITs+c2UkbZLmmIqHEe3JZrkvk6wP96HSTZkopMtyqMUnkdZLwe3MsYtPc
aiB3xGD5K5EZeVOkYAyfbpm0QhuPg9sNF16D+qhoie7vvVOeoKA5wpI8aQ6rnbCc
o/sUUlcMV1UaqeOqazXEEusAzw/Mh6mE7FIgW5f2DWzmu4BKcvbGJBbtxVAjVX6x
omaUjqVVDLXahbZefwC5VuKYe5DySzWFGVCoJ1Jh+kNtvRXRBzsODA2tQcRVKRxH
pYfYhCSN95qFV+EfYuuvRLSsUSqn4jDE2QHzxl6zi0NWvvFWPLAmr8pitEm62E8g
AUY4cbCb+KksTAin1xayDWYuTsmLaMSBkOdo7/HElf0y17a7+FbNy/lzlMylcs23
OCRE6vCa7Pk9dsHC7OlRcG5rEGFnKuZfnZdftM7nUFNtbIozdvGeJzRn9a4roRw2
fWti
=QoKV
-----END PGP MESSAGE-----
"""
await parse { packet  }, defer err, msg
console.log err
console.log util.inspect msg, { depth : null }
