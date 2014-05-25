require 'vultrlife/account/configuration'
module Vultrlife
  class Account
    def initialize
      @config  = Configuration.new
    end

    def servers
      Server.show_servers(@config.api_key)
    end

    def configure(&b)
      yield @config
      self
    end

    def server_create!(&b)
      config = Server::Configuration.new(self)
      yield config
      Server.create!(config)
    end
  end
end
