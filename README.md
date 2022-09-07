## JMH Cookbook Repository

### Important note: Berkshelf

Berkshelf support has been added to help ease upstream cookbook
tracking and dependency resolution. All cookbooks in use are defined
within the Berksfile found at the top level of this Chef repository.
The `cookbooks` directory should only contain cookbooks that are
JMH internal cookbooks, and should be prefixed with `jmh-`.

To upload cookbooks, use the `berks` command in place of `knife`:

```
$ bundle exec berks upload
```

To upload a specific cookbook, supply the name:

```
$ bundle exec berks upload jmh-apps
```

And to upload a specific cookbook without the cookbooks dependencies:

```
$ bundle exec berks upload --skip-dependencies jmh-apps
```


