require 'vultrlife/server/configuration'
module Vultrlife
  class Server
    def self.create!(config)
      plans = Vultrlife::Agent.fetch_all_plans
      #FIXME
      self.new
    end
  end
end
