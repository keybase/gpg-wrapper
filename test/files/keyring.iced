
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
  T.equal {ww:1}, json, "JSON payload checked out"
  cb()  

#-----------------

exports.nuke_ring = (T,cb) ->
  await ring.nuke defer err
  T.no_error err
  cb()