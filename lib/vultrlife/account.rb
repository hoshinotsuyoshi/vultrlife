require 'vultrlife/account/configuration'
module Vultrlife
  class Account
    attr_reader :config
    def initialize
      @config  = Configuration.new
    end

    def servers
      Server.show_servers(self)
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
