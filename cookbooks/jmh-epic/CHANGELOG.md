# Change Log

0.1.10
------
- removed `com.johnmuirhealth.epic.interconnect.auth.<type>.allowedvisittypes` from `get_interconnect_auth_clients_java_properties`

0.1.9
-----
- added clientid to the `JmhEpic.get_interconnect_check_pages(node)`
- node added to `JmhEpic.get_specific_epic_config`

0.1.8
-----
- included java_property for epic.service.clientId and added to epic databag 

0.1.7
------
- Update to property `mychart.cookie.domain`

0.1.6
-----
- Added mychart mobile checks to the `JmhEpic.get_interconnect_check_pages`

0.1.5
------
- Allow the global variables to be part of subsitution in `get_environment_java_properties`
- Updates to `mychart.datatile.url`, `mychart.cookie.domain`


0.1.4
-----
- Added `get_interconnect_auth_client` to the libraries

0.1.3
-----
- Added `get_interconnect_auth_clients_java_properties`
- Updated `java_properties.rb` to get visittype from epic/secure databag

0.1.2
-----
- added `get_interconnect_check_pages` to `helpers.rb`

0.1.1
-----
- `java_properties.rb` recipe

0.1.0
------
- Initial creation