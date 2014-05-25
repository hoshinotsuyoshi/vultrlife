require 'vultrlife/server/configuration'
module Vultrlife
  class Server
    attr_reader :subid
    def initialize(subid)
      @subid = subid
    end

    def self.create!(config)
      self.validate_config(config)
      self.exec_create
    end

    def self.show_servers(api_key)
      Agent.fetch_server_list(api_key)
    end

    private
    def self.exec_create
      subid_hash = Agent.post_create(@option)
      self.new(subid_hash['SUBID'].to_i)
    end

    def self.validate_config(config)
      plans = Agent.fetch_all_plans
      plans = plans.select{|key,value| config.plan == value['name'] }

      raise if not plans.size == 1

      regions = Agent.fetch_all_regions
      regions = regions.select{|key,value| config.region.to_s == value['name'].downcase }

      raise if not regions.keys.size == 1

      oss = Agent.fetch_all_os
      oss = oss.select{|key,value| config.os == value['name'] }

      raise if not oss.keys.size == 1

      dcid = regions.keys.first
      available_plans = Agent.fetch_availability(dcid)

      raise if not available_plans.include?(plans.keys.first.to_i)

      @option = {
        plan:    plans.keys.first.to_i,
        region:  dcid.to_i,
        os:      oss.keys.first.to_i,
        api_key: config.api_key,
      }
    end
  end
end
