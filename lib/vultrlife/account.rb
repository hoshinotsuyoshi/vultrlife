require 'vultrlife/account/configuration'
module Vultrlife
  class Account
    def initialize
      @config  = Configuration.new
      @servers = []
    end

    def servers
      Vultrlife::Agent.fetch_server_list(@config.api_key)
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
