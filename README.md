# Vultrlife

Vultr VPS API wrapper

[![travis-batch](https://travis-ci.org/hoshinotsuyoshi/vultrlife.svg)](https://travis-ci.org/hoshinotsuyoshi/vultrlife)
[![Gem Version](https://badge.fury.io/rb/vultrlife.svg)](http://badge.fury.io/rb/vultrlife)
[![Coverage Status](https://img.shields.io/coveralls/hoshinotsuyoshi/vultrlife.svg)](https://coveralls.io/r/hoshinotsuyoshi/vultrlife)
[![Code Climate](https://codeclimate.com/github/hoshinotsuyoshi/vultrlife.png)](https://codeclimate.com/github/hoshinotsuyoshi/vultrlife)

## Installation

Add this line to your application's Gemfile:

    gem 'vultrlife'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vultrlife

## Usage

### Create/Destroy Server

```
require 'vultrlife'

# Create Your Account Object
account = Vultrlife::Account.new do |account|
  account.api_key = 'xxxxxxxxxxxxxxxxxxx'
end

# Check Your Servers
puts account.servers
# => [] (if you have no servers)

# Create A Server(CentOS)
account.server_create! do |server|
  server.plan           = '768 MB RAM,15 GB SSD,0.10 TB BW'
  server.region         = :tokyo
  server.os             = 'CentOS 6 x64'
end

# Check The Server
puts account.servers.last
# => {"os"=>"CentOS 6 x64",
# "ram"=>"768 MB",
# "disk"=>"Virtual 15 GB",
# "main_ip"=>"108.61.200.210",
# "default_password"=>"eqsaqenynelu!2",
# ...and more....

# Create A Server(CustomOS)
account.server_create! do |server|
  server.plan           = '768 MB RAM,15 GB SSD,0.10 TB BW, Custom ISO'
  server.region         = :tokyo
  server.os             = 'Custom'
  server.ipxe_chain_url = 'http://......' #(optional)
end

# Check Your Servers
puts account.servers

# Destroy A Server
account.servers.first.destroy!
```

### List Plans/OSs/Regions/Plans_Regions_Availavility

```
require 'vultrlife'

Vultrlife::Agent.plans_list
#Same as API: GET /v1/plans/list

Vultrlife::Agent.regions_list
#Same as API: GET /v1/regions/list

Vultrlife::Agent.os_list
#Same as API: GET /v1/os/list

Vultrlife::Agent.regions_availability(dcid)
#Same as API: GET /v1/regions/availability

```

## Support API
```
#GET /v1/plans/list
Vultrlife::Agent.plans_list

#GET /v1/regions/list
Vultrlife::Agent.regions_list

#GET /v1/os/list
Vultrlife::Agent.os_list

#GET /v1/regions/availability
Vultrlife::Agent.regions_availability(dcid)

#GET /v1/server/list (needs api_key)
Vultrlife::Agent.server_list(api_key)

#POST /v1/server/create (needs api_key)
Vultrlife::Agent.server_create(body)

#POST /v1/server/destroy (needs api_key)
Vultrlife::Agent.server_destroy(body)

```

## Requirement
* MRI(>=1.9.3)

## Contributing

1. Fork it ( http://github.com/<my-github-username>/vultrlife/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
