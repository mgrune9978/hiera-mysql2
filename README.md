
# hiera-mysql2
This is hiera-mysql2 for use with Hiera 5 and Puppet 5.

## Description
This module is used to retrieve data from a MySQL database for use in Puppet.

## Setup

### Installation
`puppet module install nvitaterna/hiera-mysql2`

### Dependencies
If you are using Hiera-mysql under jRuby (puppetserver):
`puppetserver gem install jdbc-mysql`
If you are using Hiera-mysql under standard ruby:
`/opt/puppetlabs/puppet/bin/gem install mysql2`

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

Credit to [crayfishx/hiera-mysql](https://github.com/crayfishx/hiera-mysql) and [Telmo/hiera-mysql-backend](https://github.com/Telmo/hiera-mysql-backend).