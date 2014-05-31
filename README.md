# Vultrlife

Vultr VPS API wrapper

## Installation
### *this does not work yet*

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
account = Vultrlife::Account.new.configure do |config|
  config.api_key = xxxxxxxxxxxxxxxxxxx
end

# Check Your Servers
puts account.servers

# Order A Server
server = account.server_create! do |server|
  server.plan           = '768 MB RAM,15 GB SSD,0.10 TB BW, Custom ISO'
  server.region         = :tokyo
  server.os             = 'Custom'
  server.ipxe_chain_url = 'http://......'
end

# Check Your Servers
puts account.servers

# Destroy A Server
account.servers.first.destroy!
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/vultrlife/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
