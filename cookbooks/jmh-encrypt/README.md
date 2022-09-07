# JMH-encypt 

Cookbook for JMH for handling encryption

## Scope 

This cookbook is for handling data at rest encryption

## Requirements

- Chef 12 or higher

## Platform Support

- RHEL 7.x

## Usage

1. add recipe `jmh-encrypt::lukscrypt` to the front of your run list.  It is best to put encryption into run list as soon as possible
2. Add to your node variable list:
```ruby
   "jmh_encrypt": {
      "lukscrypt": {
        #['jmh_encrypt']['lukscrypt']['physical_disk_name']
        "physical_disk_name": "/dev/sdb", 
        #['jmh_encrypt']['lukscrypt']['volume_size']
        "volume_size": "240GB"
      }
    },
```


## Variables of interest

- `['jmh_encrypt']['luks_passphrase']` - will be set with random password if not set on your own - Used to encrypt the run
- `['jmh_encrypt']['lukscrypt']['physical_disk_name']` - disk name path
- `['jmh_encrypt']['lukscrypt']['volume_name']` - name of volume group that will have the lukscrypt
- `['jmh_encrypt']['lukscrypt']['device_prefix']` - path of the volume group
- `['jmh_encrypt']['lukscrypt']['volume_size']` - Size of luks volume. i.e. '1GB', '600MB'
- `['jmh_encrypt']['lukscrypt']['encrypted_disk_name']` - name of encrypted disk and file path of encrypted drive

## Other Notes

- vgremove (removes the volume group).  Good for starting over when there is a problem