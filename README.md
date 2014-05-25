vultrlife
=========

Vultr VPS API wrapper

### this does not work yet

Usage:
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
