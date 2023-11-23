# luks
This cookbook provides a Chef custom resource for adding and removing LUKS(2) keyslots.

## Implementation
The resource `luks_key` has the properties `passphrase` and `master_passphrase`.
The master passphrase is by default read from a chef-vault.
Its function is to authorize the addition of new passphrases.
The default location of the vault is defined by the node attributes: `default['luks']['master_passphrase']['vault']['luks_passphrases']` and `default['luks']['master_passphrase']['vault_item']['luks_master_passphrase']`.
It will be ignored if a `master_passphrase` is explicitly given in the resource definition.

The setup of the encrypted device is outside of the scope of this cookbook.
The passphrase must conform to the requirements given in `node['luks']['passphrase_acceptance_regex']` (default: keys identical on german and american keyboard, 12-42 characters long).
The property `passphrase` is required as it is the key that is to be added/removed.

This resource also checks whether or not the passphrase has already been added or removed.
Should a key already exist or have been removed chef will do nothing.
This also prevents two keyowners from having the same key which LUKS2 would allow.
Should all keyslots be full `luks_key` will fail and the Chef run will be aborted (unless `ignore_failure` is enabled).

## Usage
Add a luks key/passphrase:
```
luks_key '<name-of-device>' do
  passphrase '<passphrase>'
  [action :remove/:add] # default = :add
  end
end
```

## Features
- can add LUKS(2) keys
- can remove LUKS(2) keys
- can prevent redundant keys

## Contribute
- Issue Tracker: https://git.gsi.de/chef/cookbooks/luks/-/issues
- Source Code: https://git.gsi.de/chef/cookbooks/luks

# Authors
Samuel Hasert <s.hasert@gsi.de>
Christopher Huhn <c.huhn@gsi.de>

# License
Copyright 2023 GSI Helmholtzzentrum fuer Schwerionenforschung GmbH
