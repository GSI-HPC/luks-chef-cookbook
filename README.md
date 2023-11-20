# luks

TODO: Enter the cookbook description here.

Add a luks key:

```
luks_key '<name-of-device>' do
  passphrase '<passphrase>'
  [action :remove/:add] # default = :add
  end
end
```
