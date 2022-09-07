Data Bags
---------

This directory contains directories of the various data bags you create for your infrastructure. Each subdirectory corresponds to a data bag on the Chef Server, and contains JSON files of the items that go in the bag.

First, create a directory for the data bag.

    mkdir data_bags/BAG

Then create the JSON files for items that will go into that bag.

    $EDITOR data_bags/BAG/ITEM.json

The JSON for the ITEM must contain a key named "id" with a value equal to "ITEM". For example,

    {
      "id": "foo"
    }

Next, create the data bag on the Chef Server.

    knife data bag create BAG

Then upload the items in the data bag's directory to the Chef Server.

    knife data bag from file BAG ITEM.json


Encrypted Data Bags
-------------------

Added in Chef 0.10, encrypted data bags allow you to encrypt the contents of your data bags. The content of attributes will no longer be searchable. To use encrypted data bags, first you must have or create a secret key.

    openssl rand -base64 512 > secret_key

You may use this secret_key to add items to a data bag during a create.

    knife data bag create --secret-file secret_key passwords mysql

You may also use it when adding ITEMs from files,

    knife data bag create passwords
    knife data bag from file passwords data_bags/passwords/mysql.json --secret-file secret_key

The JSON for the ITEM must contain a key named "id" with a value equal to "ITEM" and the contents will be encrypted when uploaded. For example,

    {
      "id": "mysql",
      "password": "abc123"
    }

Without the secret_key, the contents are encrypted.

    knife data bag show passwords mysql
    id:        mysql
    password:  2I0XUUve1TXEojEyeGsjhw==

Use the secret_key to view the contents.

    knife data bag show passwords mysql --secret-file secret_key
    id:        mysql
    password:  abc123


Apache Redirects Maintenance 
-----------------------------

Proxied applications are able to be put into a maintenance mode, ie. send to a maintenance page, depending on the data within their data bag.
Maintenance windows can be set on the fly using `['maintenance']` or scheduled using `['maintenance_windows']`.

Within the data bag for a proxy
* `['maintenance']` - Mash of chef environments and whether or not they should be in maintenance
```
  "maintenance": {  "fhprod": false, "awsdev" : false, "_default": false }
```
* `['maintenance_page']` - location of error page relative to root context 
``` 
"maintenance_page": "/jmherror/myjmh_maintenance.html" 
```
* `['maintenance_windows']` - Mash of maintenance windows. (See table for fields)

| Window Field | Explanation |
|---------|-----------|
| Mash Key | Name of Window (Used for cross reference of other proxies down during same maintenance window) |
| `env` | Array of chef environments window is affecting |
|`start`| Start time of window in Date Format of **YY-MM-DD HH:MM:DD TMZ**|
|`stop`| Stop time of window in Date Format of **YY-MM-DD HH:MM:DD TMZ**|


      "maintenance": {  "fhprod": false,
  			     		"arstage": false,
  		    			"awsdev": false,
  		    			"awsdev": false,  					
  		    		    "_default": false 
  		    		    },
       "maintenance_page": "/jmherror/special_maintenance.html",
       "maintenance_windows": { "MyMaintWindow": 
       			{ "env": [ "fhprod", "fhsbx" ], 
       			  "start" : "2014-09-21 00:00:00 PDT", 
       			  "stop": "2014-09-21 03:00:00 PDT"}	
  	     	    }
