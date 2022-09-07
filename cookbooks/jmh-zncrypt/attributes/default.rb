#
# Author:: Eddie Garcia (<eddie.garcia@gazzang.com>)
#  Updated:: Melinda Moran 
# Cookbook Name:: jmh-zncrypt
# Attribute:: default
#
# Copyright 2012, Gazzang, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# All rights reserved - Do Not Redistribute
#
default[:zncrypt][:kernel_version] = '2.6.32-431.5.1'

default[:zncrypt][:organization] = "johnmuirhealth"
default[:zncrypt][:auth_code] = "0nlYRrPX54ztoVlXd1fu"

# setup the mount point for zncrypt and storage directory

default[:zncrypt][:mount_point] = '/zncrypt/zncrypted'
default[:zncrypt][:storage] = '/zncrypt/storage'

# setup the email for the license key for administrator to approve
# Email1 should be the PRIMARY admin for Gazzang they have on file.
default[:zncrypt][:admin_email1] = 'melinda.moran@johnmuirhealth.com'
default[:zncrypt][:admin_email2] = 'scott.marshall@johnmuirhealth.com'


# optionally setup a passphrase and passphrase2
# when used as an attribute this will override the passphrase databag, useful when databags are not supported
# NOTE: passphrase must be between 15 and 32 characters.

#TODO  Lets get this working without databag first 
default[:zncrypt][:passphrase] = 'J0hn Muir H3alth'
#default[:zncrypt][:passphrase2] = 'pleasechangeme1'

default[:zncrypt][:email_root_cron] = 'false'

