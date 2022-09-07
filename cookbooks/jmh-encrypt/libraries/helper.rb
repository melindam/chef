module JmhEncrypt
  # Helper module for jmh-encrypt cookbook_file
  module Helper
    extend Chef::Mixin::ShellOut

    def self.create_volume_group(volume_name, physical_disk_name)
      shell_out!("vgcreate #{volume_name} #{physical_disk_name}")
    end

    def self.create_volume(size, device_name, volume_name)
      shell_out!("lvcreate -L#{size} -n #{device_name} #{volume_name}")
    end

    def self.create_luks_device(passphrase, device_path, disk_name)
      shell_out!("echo #{passphrase} | cryptsetup open #{device_path} #{disk_name}")
    end

    def self.format_ext4(disk_name)
      shell_out!("mkfs.ext4 #{disk_name}")
    end

    def self.volume_group_available?(volume_group)
      shell_out!("vgdisplay | grep #{volume_group}")
      true
    rescue
      false
    end

    def self.disk_available?(disk_name)
      shell_out!("fdisk -l | grep #{disk_name}")
      true
    rescue
      false
    end
  end
end
