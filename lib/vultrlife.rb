module Vultrlife
  def self.configure(&b)
    yield self
    self
  end

  def self.api_key=(api_key)
    @api_key = api_key
  end
end
