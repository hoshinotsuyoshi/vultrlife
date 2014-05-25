require 'vultrlife/server/configuration'
module Vultrlife
  class Server
    def self.create!(config)
      self.validate_config(config)
      self.new
    end

    private
    def self.validate_config(config)
      plans = Vultrlife::Agent.fetch_all_plans
      plans = plans.select{|key,value| config.plan == value['name'] }

      raise if not plans.size == 1

      regions = Vultrlife::Agent.fetch_all_regions
      regions = regions.select{|key,value| config.region.to_s == value['name'].downcase }

      raise if not regions.keys.size == 1
      available_plans = Vultrlife::Agent.fetch_availability(regions.keys.first)

      raise if not available_plans.include?(plans.keys.first.to_i)
    end
  end
end
