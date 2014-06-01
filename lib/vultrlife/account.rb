require 'vultrlife/account/configuration'
module Vultrlife
  class Account
    attr_reader :config
    attr_accessor :api_key
    def initialize(&b)
      @api_key = ''
      if block_given?
        yield self
      end
      self
    end

    def servers
      Server.show_servers(self)
    end

    def server_create!(&b)
      config = Server::Configuration.new(self)
      yield config
      Server.create!(config)
    end
  end
end
