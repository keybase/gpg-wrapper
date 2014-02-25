## 0.0.34 (2014-02-25)

Bugfixes:

  - Upgrade to pgp-utils v0.0.15 to allow null emails

## 0.0.32 (2014-02-20)

Features :
 
  - If quiet is on, and there's an error, we'll pass stderr back via the Error object.

## 0.0.31 (2014-02-18)

Bugfixes:

  - More robust and secure file-touching mechanism for new Alt primary key dirs

## 0.0.31 (2014-02-18)

Bugfixes:

  - Issues with Alt primary dirs on windows being created for the first time.

## 0.0.30 (2014-02-17)

Bugfixes:

  - We dropped set_log a while ago, when we moved spawn functionality into iced-spawn.  So add it back.

## 0.0.29 (2014-02-17)

Bugfixes

  - More windows testing bugfixes

## 0.0.28 (2014-02-16)

Features:

  - New indexing system; can read in the whole keychain with -k and then access the index in memory (close issue #3)
  - Small tweaks and features additions for new keybase-node-installer version


## 0.0.27 (2014-02-15)

Bugfixes:

  - Upgrade to `iced-spawn` for all spawning work.
  - Fix bugs in windows

## 0.0.25 (2014-02-14)

Bugfixes:
  
  - `verify_sig` now goes through `one_shot_verify` which should ease the dependence on our ability to parse the text output of GPG

Features:

  - Inaugural CHANGELOG.md
