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
  end
end
