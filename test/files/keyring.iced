
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

kaiser2 =
  key_data : """
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
Comment: GPGTools - https://gpgtools.org

mQENBFLf0DYBCADGz/jWmSDY8c4yVorLgDXK1GpHmqmGOaacBjdSC0Os0+oBcvI7
o7rVZkkOeHoLGfr4HaQ6iXF61PxMjRpvUmDMrznrYGnOsSiiY0S6IFmAoEnu7BqI
2ZPQEwqxV4o9iQ6ttffh0LC/5IX3+0sXt6uWebAyE0fW3Rw1drSaElUdzXRu7/nw
e75oLhNSVguLFMhhs6VvUglcYRsZJN+hNOW0oVOIBWHDCtI713U/wFepaOov0g48
Ysj2gFLnhUMGPgb+yTKeDLvlQQCZoIXBWWTy7sM/LU0xsegP0Wpsv+aj7fNcoxYp
tuqQwPOzu35B7J4++ECmQ0qoVND9j5iChA2xABEBAAG0IkthaXNlciBXaWxoZWxt
IDxrYWlzZXIyQHlhaG9vLmNvbT6JAT0EEwEKACcFAlLf0DYCGwMFCRLMAwAFCwkI
BwMFFQoJCAsFFgIDAQACHgECF4AACgkQY+EQEyiPLUiCcQf/REXdwDfJRHc7DpWJ
M/o+NDke4d60gh3wtNRUWlsbAF/Xc1aZjEJt0xRIx3QJ8P5+FYfMsk2/05UfXmrg
KE69AEP2x3FcbnkYeSG0jwbDi5h7such17SDxV9M/s4iHjJKBglyDxYltG2xZ8Xu
NNTi2VkvvulrRcwonQr/hPDibMKIgY7Xrxw3nZK/pOOXaidcIvuoGpOd9w3UniGc
zOzSi3CqTQrpf+5/p0rZE2tdJdNTm2MUww8FiUzpzdUfMAunVSpK1WazpWXkJ9sS
4H6dE+GUWh71f4j69NNfzOG4YWQ6syjJ12BtlLRNl403LvPubhVaKr0gHF5wEeI0
4h0YR7kBDQRS39A2AQgA6Vfl/9NBltJOxQ921rJJTqsjxW/chIX1HGYEYWRrJrfD
iEoC1jYDOKmP6q6PYREeyhB1G5uER2FQnjtxY8Wo+BpwsJ+s/stgRZoHUM2AsmPb
rnEt8J781trSjbTuySgRkqsQAQizhrsAq0jnpOCmAPVbsFvC4oV9kjiXDOet2j9j
tfZ5FnfESqQ0tmrdIXvKaa3+jE5hnRvyhBrwyoYny6SBw4eqogUjQnUa1yo4X0Si
dPmNDA6DdIFG6+OxR3emRNxeuYRq3oHJLAalGlhMQCn8QK1RyoyRqDcekMHB0hYV
uNgxgta11hIdipBohrJIeKVcGKXt29XSnS0iWdm/DQARAQABiQElBBgBCgAPBQJS
39A2AhsMBQkSzAMAAAoJEGPhEBMojy1I1t8H/3hXg/3WwN33iY1bodU8oXYVBbKG
pjs/A/fP/H3+3MqG6z/sspUfXluS7baNRmg5HB300vMGqPRJ5EU5/anOu/EJxj1A
NJpSiJnXyjwVx7EviMgLPlZC0HTYNPsiXZLe7p/WAWHy5HRH9iAgu0IOPon1MniV
9lgJHsOS+zF+ostVB6PFglEJt4y7ySeFuxpRTi0ulYyO/LHW7nJZkl6xzpvykJws
3it8W3ecYAodkySzgLN8zqS8nlqlsJgO/NYIQd3c67MKA+92A75VlCMJ25SrsaVm
Enqh2naqYfmkmhWk5KInf02pSAwD5I/roTYO9kO1QjLrVj1d058K2/T2Z0o=
=U857
-----END PGP PUBLIC KEY BLOCK-----
"""
  username : "kaiser2@yahoo.com"
  fingerprint : "A03CC843D8425771B59F731063E11013288F2D48"
  payload_json : { ww : 1 }
  payload : '{ "ww" : 1 }\n'
  sig : """-----BEGIN PGP MESSAGE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
Comment: GPGTools - https://gpgtools.org

owEBQwG8/pANAwAKAWPhEBMojy1IAcsTYgBS39KUeyAid3ciIDogMSB9CokBHAQA
AQoABgUCUt/SlAAKCRBj4RATKI8tSN+tB/90cxDDxC0PjoPqbO2ZrbI1q2FGyZI3
Ayukt+u/cTadECcigJzE05ymKevKCVJFHASEp4SMn9nW4QSD5fTRcqo6QBfWImQi
UYbirBvhejAARusJmLKtpmosxxsiEYQ1bcFJjx2+UQLr40uw5RHXfgP8CuUqadrw
Wm+wqLwUwXxbrYb5FCZ8nziEUwOl2rpqV1NIj59D3BZps43Q5QCCTRZF5+eJJyg+
AhyYGythrOMbYKWmRRGhIdy3QU34IHGxNh3o2bz6YBiM/JD8CY0M0HT33xU93LvB
7UowhdY7p9M8R0Ql21T4+5AOxPxHQIypRKOl5oJPvZg8avtDT8sc5fRw
=Uy2n
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

exports.test_oneshot_verify = (T,cb) ->
  key = ring.make_key kaiser2
  await key.save defer err
  T.no_error err
  await ring.oneshot_verify { query : kaiser2.username, single : true, sig : kaiser2.sig }, defer err, json
  T.no_error err
  T.equal kaiser2.payload_json, json, "JSON payload checked out"
  cb()  

#-----------------

exports.test_verify_sig = (T,cb) ->
  await key.verify_sig { which : "something", payload : kaiser2.payload, sig : kaiser2.sig }, defer err
  T.no_error err
  cb()

#-----------------

exports.test_import_by_username = (T,cb) ->
  key = ring.make_key {username : "<gman@theblackhand.io>"}
  await key.load defer err
  T.no_error err
  T.equal key.uid().username, 'Gavirilo Princip', "username came back correctly after load"
  cb()

#-----------------

exports.test_import_by_username_with_space = (T,cb) ->
  key = ring.make_key keybase_v1_index
  await key.save defer err
  T.no_error err
  key = ring.make_key {username : "(v1) <index@keybase.io>"}
  await key.load defer err
  T.no_error err
  T.equal key.uid().username, 'Keybase.io Index Signing', "username came back correctly after load"
  cb()

#-----------------

keybase_v1_index = 
  key_data : """
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
Comment: GPGTools - http://gpgtools.org

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
=kK8c
-----END PGP PUBLIC KEY BLOCK-----
"""

#-----------------

exports.nuke_ring = (T,cb) ->
  await ring.nuke defer err
  T.no_error err
  cb()

#-----------------