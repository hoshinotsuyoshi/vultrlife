require 'vultrlife/server/configuration'
module Vultrlife
  class Server < Hash
    attr_reader :subid
    def initialize(subid, account=nil, hash=nil)
      @subid = subid
      @account = account
      self.merge!(hash) if hash
    end

    def destroy!
      Agent.server_destroy(SUBID: @subid, api_key: @account.api_key)
      self['destroyed'] = true
      @subid
    end

    def destroyed?
      !!self['destroyed']
    end

    def self.create!(config)
      self.set_option(config)
      self.exec_create
    end

    def self.show_servers(account)
      servers = Agent.server_list(account.api_key)
      servers = servers.map do |subid, attributes|
        self.new(subid, account, attributes)
      end
    end

    # helpers
    #
    def self.exec_create
      subid_hash = Agent.server_create(@option)
      self.new(subid_hash['SUBID'].to_i)
    end

    def self.set_option(config)
      @option = {api_key: config.api_key}
      set_plan(config)
      set_region(config)
      set_os(config)
      validate_region_availability(config)

      if config.ipxe_chain_url
        @option[:ipxe_chain_url] = config.ipxe_chain_url
      end
    end

    def self.set_plan(config)
      plans = Agent.plans_list
      plans = plans.select{|key,value| config.plan == value['name'] }
      raise if not plans.size == 1
      @option[:VPSPLANID] = plans.keys.first.to_i
    end

    def self.set_region(config)
      regions = Agent.regions_list
      regions = regions.select{|key,value| config.region.to_s == value['name'].downcase }
      raise if not regions.keys.size == 1
      @option[:DCID] = regions.keys.first.to_i
    end

    def self.set_os(config)
      oss = Agent.os_list
      oss = oss.select{|key,value| config.os == value['name'] }

      raise if not oss.keys.size == 1
      @option[:OSID]    = oss.keys.first.to_i
    end

    def self.validate_region_availability(config)
      available_plans = Agent.regions_availability(@option[:DCID]).map(&:to_i)

      raise if not available_plans.include?(@option[:VPSPLANID])
    end
  end
end
