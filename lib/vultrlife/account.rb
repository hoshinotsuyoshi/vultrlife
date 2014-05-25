require 'vultrlife/account/configuration'
module Vultrlife
  class Account
    attr_reader :servers

    def initialize
      @config  = Configuration.new
      @servers = []
    end

    def configure(&b)
      yield @config
      self
    end

    def server_create!(&b)
      yield Server::Configuration.new
      self
    end

    class Server
      class Configuration
        attr_writer :region, :plan, :os, :ipxe_chain_url
      end
    end
  end
end
