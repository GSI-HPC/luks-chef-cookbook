# luks
This project implements the addition and removal of LUKS(2) keys through chef.

## Implementation
Whenever a  `luks_key` resource is created a luks passphrase is added/removed. This resource has the properties `passphrase` and `master_passphrase`. The `master_passphrase` can be any existing key.
The setup of the encrypted device does not have to happen at install time. It should conform to the requirements given in `/attributes/default.rb` (keys identical on german and american keyboard, 12-42 characters long). Its function is to authorize the addition of new passphrases. The property `passphrase` is required as it is the key that is to be added/removed. This resource has the option to add or remove a luks passphrase. It also checks wether or not the passphrase has already been added or removed. Should a key already exist or been removed chef will do nothing. This prevents two keyowners from having the same key which LUKS2 allows. Should all keyslots be full LUKS2 will raise an error and exit with the code 1. 

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


