module Vultrlife
  class Account
    def configure(&b)
      yield self
      self
    end

    def api_key=(api_key)
      @api_key = api_key
    end
  end
end
