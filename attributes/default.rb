default_unless['luks']['master_passphrase']['vault']      = 'luks_passphrases'
default_unless['luks']['master_passphrase']['vault_item'] = 'luks_master_passphrase'

# - keys that are identical on American and German keyboards :)
# - between 12 and 42 characters
default['luks']['passphrase_acceptance_regex'] =
  %r{^[1234567890qwertuiopasdfghjklxcvbnm
       ,.!$%QWERTUIPASDFGHJKLXCVBNM]{12,42}$
  }x
