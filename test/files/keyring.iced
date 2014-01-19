
keyring = require '../../lib/keyring'

#-----------------------------------

class Log extends keyring.Log

#-----------------------------------

ring = null

#-----------------

exports.init = (T, cb) ->
  keyring.init {
    get_preserve_tmp_keyring : () -> false
    get_tmp_keyring_dir : () -> "."
    log : new Log()
  }
  cb()

#-----------------

exports.make_ring = (T,cb) ->
  await keyring.TmpKeyRing.make defer err, tmp
  T.no_error err
  T.assert tmp, "keyring came back"
  ring = tmp
  cb()

#-----------------

exports.test_import = (T,cb) ->
  key_data = """
  -----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.14 (GNU/Linux)

mI0EUqpp2QEEANFByr3uPGsG5DqmV3kPLsTEmew5d8NcD3SqASas342LB5sDE0D6
0fTDvjLYAiCTgVlZrSIx+SeeskygKH/AwnTCBK04V0HgpR0tyw+dGIV5ujFIo236
O8XvIqaVoR1/zizy8fOSaFqr8rPQf3JYWxQn8IMLUS+ricOUZS/YSgNVABEBAAG0
M0dhdmlyaWxvIFByaW5jaXAgKHB3IGlzICdhJykgPGdtYW5AdGhlYmxhY2toYW5k
LmlvPoi+BBMBAgAoBQJSqmnZAhsDBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIe
AQIXgAAKCRDuXBLqbhXbknHWBACGwlrWuJyAznzZ++EGpvhVZBdgcGlU3CK2YOHC
M9ijVndeXjAtAgUgW1RPjRCopjmi5QKm+YN1WcAdf6I+mnr/tdYhPYnRE+dNsEB7
AWGsiwZOxQbwtCOIR+5AU7pzIoIUW1GsqQK3TbiuSRYI5XG6UdcV5SzQI96aKGvk
S6O6uLiNBFKqadkBBADW31A7htB6sJ71zwel5yyX8NT5fD7t9xH/XA2dwyJFOKzj
R+h5q1KueTPUzrV781tQW+RbHOsFEG99gm3KxuyxFkenXb1sXLMFdAzLvBuHqAjQ
X9pJiMTCAK7ol6Ddtb/4cOg8c6UI/go4DU+/Aja2uYxuqOWzwrantCaIamVEywAR
AQABiKUEGAECAA8FAlKqadkCGwwFCRLMAwAACgkQ7lwS6m4V25IQqAQAg4X+exq1
+wJ3brILP8Izi74sBmA0QNnUWk1KdVA92k/k7qA/WNNobSZvW502CNHz/3SQRFKU
nUCByGMaH0uhI6Fr1J+pjDgP3ZelZg0Kw1kWvkvn+X6aushU3NHtyZbybjcBYV/t
6m5rzEEXCUsYrFvtAjG1/bMDLT0t1AA25jc=
=59sB
-----END PGP PUBLIC KEY BLOCK-----
"""
  key = ring.make_key {
    key_data,
    fingerprint : "1D1A20E57C763DD42258FBC5EE5C12EA6E15DB92"
    username : "gavrillo"
  }
  await key.save defer err
  T.no_error err
  await key.load defer err
  T.no_error err
  cb()

#-----------------

exports.nuke_ring = (T,cb) ->
  await ring.nuke defer err
  T.no_error err
  cb()