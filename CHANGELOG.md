# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [0.1.1] - 2023-11-28

### Changed

* Relax `chef_version` requirements
* Replace `Policyfile.rb` with `Berksfile`
* Lower attribute precededence of default vault names to `default_unless`
* Allow I and G in default passphrase regex

## [0.1.0] - 2023-11-24

### Added

* Cookbook created with
  ```
  cinc generate cookbook -m "linuxgroup@gsi.de" \
      --copyright "GSI Helmholtzzentrum für Schwerionenforschung GmbH" \
      -I gplv3 -V luks
  ```
* Test suite adapted to internal standards
* Encrypted loopback device `/dev/mapper/cryptokitchen` created
  from `/tmp/cryptokitchen.loop`, formatted as `ext4` and mounted as `/mnt`
* Install cryptsetup in `default` recipe
* Initial implementation of `luks_key`
* Document cookbook in README
