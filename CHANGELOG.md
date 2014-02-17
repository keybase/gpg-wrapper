## 0.0.29

Bugfixes

	- More windows testing bugfixes


## 0.0.28 (2014-02-16)

Features:

	- New indexing system; can read in the whole keychain with -k and then
	  access the index in memory (close issue #3)
	- Small tweaks and features additions for new keybase-node-installer version


## 0.0.27 (2014-02-15)

Bugfixes:

	- Upgrade to `iced-spawn` for all spawning work.
	- Fix bugs in windows

## 0.0.25 (2014-02-14)

Bugfixes:
  
	- `verify_sig` now goes through `one_shot_verify` which should ease the dependence
	on our ability to parse the text output of GPG

Features:

	- Inaugural CHANGELOG.md
