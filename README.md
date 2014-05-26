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

```
require 'vultrlife'

account = Vultrlife::Account.new.configure do |config|
  config.api_key = xxxxxxxxxxxxxxxxxxx
end

raise if account.servers.size.nonzero?

server = account.server_create! do |server|
  server.region = :tokyo
  server.plan   = :starter
  server.os     = :custom
  server.ipxe_chain_url = 'http://......'

  server.verify_plan do |verify|
    verify.costs_at_most = 7
    verify.vcpu_count    = 1
    verify.ram           = 1024
    verify.disk          = 30
    verify.bandwidth     = 2
  end
end

account.servers


# this feature is big....
server.ssh do
  'your awesome command...'
end

```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/vultrlife/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
