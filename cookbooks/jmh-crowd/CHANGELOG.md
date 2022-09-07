# CHANGELOG for jmh-crowd
==========================

This file is used to list changes made in each version of jmh-crowd.

to come soon:

2.4.6
------
- upgrade to crowd 4.0.2
- set `['jmh_db']['default_storage_engine'] = 'InnoDB'`
- move to java 11

2.4.5
------
- upgraded `install_certificate.rb` to not use java recipe

2.4.4
-----
- Removed deprecated build-essential cookbook.

2.4.3
-----
- systemd upgrade

2.4.2
------
- node.set changed to node.normal
- secure_password changed to random_password

2.4.1
-----
- updated crowd watch script to remove lock info and move it to flock

2.4.0
-----
- Crowd 3.2.5 install

2.3.1
-----
- Systemd added

2.3.0
----
- Upgrades to crowd version are handled.

2.2.0
-----
- create a new crowd certificate for valid hostname calls same in all environments
- include hostname value per environment to find that hostname when the certificate is installed

2.1.1
-----
Added Apache 2.4 to crowd console

2.1.0
-----
- upgrade to 2.8.3
- moved mysql variables from role to cookbook
- foodcritic and rubocop run
- Adding the crowd.cfg.xml file template which adds an xml parsing library

2.0.3
-----
<REMOVED>

2.0.2
-----
<REMOVED>

2.0.1
-----
Fix to where we put the cert in java

2.0.0
-----
uses new version of mysql cookbook - called from jmh-db resources

1.0.6
-----
Updated mod_authnz_crowd for RHEL 6

1.0.5
-----
moved to use mysql_connector_j cookbook provider

1.0.4
-----
Making it so it only installs on RHEL 5 with libcurl.3

1.0.3
-----
crowd authentication with apache module

1.0.2
-----
uses jmh-java cookbook

1.0.0
-----
* Initial release of jmh-crowd by scottymarshall



- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
