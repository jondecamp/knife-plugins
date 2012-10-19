knife-plugins
=============

Collection of knife plugins for Opscode Chef

Copy to ~/.chef/plugins/knife

### nodeclone.rb
Clones a node's environment and/or run_list to one or more target nodes.

**Usage**
```
knife node clone SOURCE TARGET[s]
-e, --env                        Clone environment of SOURCE to TARGET[s]
-r, --runlist                    Clone run_list of SOURCE to TARGET[s]
```

### More information on knife plugins
http://wiki.opscode.com/display/chef/Knife+Plugins

Author
======
Author:: Jon DeCamp (mailto:jon.decamp@nordstrom.com)

Copyright
=========
Copyright 2012 Nordstrom, Inc.

License
=======
Apache License 2.0. See LICENSE.txt