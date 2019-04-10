
# hiera-mysql2
This is hiera-mysql2 for use with Hiera 5 and Puppet 5.
This module was forked as I was not interested in using anyting other than the jdbc-mysql gem and wanted to install this gem using puppet, which was not possible with the parent module.

## Description
This module is used to retrieve data from a MySQL database for use in Puppet.

## Setup

### Installation
Add this module to your puppet file

### Dependencies
puppetserver gem install jdbc-mysql`

### Configuration
hiera.yaml:
```
- name: "MySQL lookup"              # this can be changed
  lookup_key: mysql2_lookup_key     # this must be mysql2_lookup_key
  paths:                            # can be any files you want this module to check for data
    - "common.sql"
```

Assuming the default data directory is ./data. 
./data/common.sql:
```
---
:dbconfig:
  host: dev1                                # mysql server host
  username: root                            # mysql user
  password: "%{lookup('mysqlpassword')}"    # mysql password
  database: puppet                          # mysql database
  port: 3306                                # mysql port (optional, defaults to 3306)
machines: SELECT * FROM machines;           # queries can be named as you like
items: SELECT * FROM items;
```
NOTE: any of these fields, including the query, can reference can use hiera lookups.

### Usage

When in puppet, use hiera like you normally would:
```
$machines = lookup('machines')
```

### Credits

Credit to [crayfishx/hiera-mysql](https://github.com/crayfishx/hiera-mysql) and [Telmo/hiera-mysql-backend](https://github.com/Telmo/hiera-mysql-backend) and [nvitaterna/hiera-mysql2](https://github.com/nvitaterna/hiera-mysql2).
