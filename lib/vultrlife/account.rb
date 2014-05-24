module Vultrlife
  class Account
    class Configuration
      def api_key=(api_key)
        @api_key = api_key
      end
    end

    def initialize
      @config = Configuration.new
    end

    def configure(&b)
      yield @config
      self
    end
  end
end
