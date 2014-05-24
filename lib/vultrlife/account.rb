require 'vultrlife/account/configuration'
module Vultrlife
  class Account
    def initialize
      @config = Configuration.new
    end

    def configure(&b)
      yield @config
      self
    end
  end
end
