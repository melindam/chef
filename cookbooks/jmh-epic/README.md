# jmh-epic

This cookbook is used to control all things Epic for JMH.  If you need to know something about an epic product, (i.e. the context of the mychart instance or its ip address) this cookbook will be the controller of this information.

Variables
--------
* `['jmh_epic']['environment']` - epic environment that is associated with a given chef environment.  A one-to-one relationship.  We define it within the chef environment.
* `['jmh_epic']['data_bag']` - Data Bag for epic environments. Each environment has its own Data Bag Item


Methods
--------

* `JmhEpic.get_epic_config(node)` - returns the data bag item of the epic environment for the given node as a Hash. 
* `JmhEpic.get_specific_epic_config('env', node)` - returns the data bag item of the Specified epic environment as a Hash.
