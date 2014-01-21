
keyring = require '../../lib/keyring'

#-----------------------------------

class Log extends keyring.Log
  debug : (x) ->

#-----------------------------------

ring2 = ring = null
key = null
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
fingerprint = "1D1A20E57C763DD42258FBC5EE5C12EA6E15DB92"

payload = "I hereby approve of the Archduke's assassination.  Please spare his wife.\n"
sig = """
-----BEGIN PGP MESSAGE-----
Version: GnuPG v1.4.14 (GNU/Linux)

owGbwMvMwMT4LkboVZ7o7UmMpwOSGIJu/27zVMhILUpNqlRILCgoyi9LVchPUyjJ
SFVwLErOSCnNTlUvVkgsLgaizLzEksz8PD0FhYCc1MTiVIXigsSiVIWMzGKF8sy0
VD2ujjksDIxMDGysTCBzGbg4BWCWrVNjYWg1Py9w8X/oMuuysk7JcilXkWqjy9uX
N8bOfbp+ZZK7rYGMD++edRt9Mk5ITp+2cPcunVXv2FmCO6d6SD3lnOybvcXytJFt
S+fz1cqTPdi3dT47XXj97IWY65u1pO9HBUZmy0/YzihX4Pz/ZIO7hnfb1N4l7Fw/
Hz30FTkcaHWq7oPoHAWeYwA=
=2ENa
-----END PGP MESSAGE-----
"""

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
  key = ring.make_key {
    key_data,
    fingerprint,
    username : "gavrilo"
  }
  await key.save defer err
  T.no_error err
  await key.load defer err
  T.no_error err
  cb()

#-----------------

exports.test_verify = (T,cb) ->
  await key.verify_sig { sig, payload, which : "msg" }, defer err
  T.no_error err
  cb()

#-----------------

exports.test_read_uids = (T, cb) ->
  await ring.read_uids_from_key { fingerprint }, defer err, uids
  T.no_error err
  T.equal uids.length, 1, "the right number of UIDs"
  # Whoops, there was as typo when I made this key!
  T.equal uids[0].username, "Gavirilo Princip" , "the right username"
  cb()

#-----------------

exports.test_copy = (T,cb) ->
  await keyring.TmpKeyRing.make defer err, ring2
  T.no_error err
  T.assert ring2, "keyring2 was made"
  await ring2.read_uids_from_key { fingerprint }, defer err, uids
  T.assert err, "ring2 should be empty"
  key2 = key.copy_to_keyring ring2
  await key2.save defer err
  T.no_error err
  await key2.load defer err
  T.no_error
  await key2.verify_sig { sig, payload, which : "key2" }, defer err
  T.no_error err
  await ring2.nuke defer err
  T.no_error err
  cb()

#-----------------

exports.test_find = (T, cb) ->
  await ring.find_keys { query : "gman@" }, defer err, id64s
  T.no_error err
  T.equal id64s, [ fingerprint[-16...] ], "got back the 1 and only right key"
  cb()

#-----------------

exports.test_list = (T,cb) ->
  await ring.list_keys defer err, id64s
  T.no_error err
  T.equal id64s, [ fingerprint[-16...] ], "got back the 1 and only right key"
  cb()

#-----------------

exports.test_one_shot = (T,cb) ->
  await ring.make_oneshot_ring { query : fingerprint, single : true }, defer err, r1
  T.no_error err
  T.assert r1, "A ring came back"
  await r1.nuke defer err
  T.no_error err
  cb()

#-----------------

exports.nuke_ring = (T,cb) ->
  await ring.nuke defer err
  T.no_error err
  cb()