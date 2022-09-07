# CHANGELOG for jmh-archiva

This file is used to list changes made in each version of jmh-archiva.

1.0.11
-----
- updates to the `archiva.erb` file
- moved archiva.chef to the conf folder

1.0.10
------
- updated to archiva 2.2.5

1.0.9
------
- cleaned up call to app_download databag in `app_download.rb`

1.0.8
-----
- node.set changed to node.normal
- secure_password changed to random_password

1.0.7
------
- Added permissions to the app_download files

# 1.0.6
-------
- password expiration to no longer be an issue and set for 99999 days

# 1.0.5
-------
- shift to consolidate apache webserver needs to jmh-webserver

# 1.0.4
-------
- Turn off registration
- made it only accessible internally
- removed calls to jmh_app

# 1.0.3
-------
- Systemd intelligence, included to start after mysql.service
- Disable Registration link on login page

# 1.0.2
-------
- Apache 2.4 intelligence

# 1.0.1
-------
- Allow more than one login to app downloads

# 1.0.0
-------
- Upgrade to Archiva 2.2
- Moved remote repos to databag - archiva/repositories.json
- Move to `jmh-java`

## 0.1.6
--------
* uses jmh-db now to create MySQL DB along with new version of mysql cookbook

## 0.1.5
---------
* Updated to point to jmh-java
* Using jmh-webserver
* removal of fog and now using jmh_utilities_s3_download

## 0.1.4
-----
* Creates new web server URL to download the MyJMH mobile app.
* moved to use mysql_connector_j cookbook provider

0.1.0
-----
* Initial release of jmh-archiva by Melinda



- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
