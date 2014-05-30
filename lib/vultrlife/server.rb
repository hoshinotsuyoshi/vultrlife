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
      Agent.post_destroy(SUBID: @subid, api_key: @account.config.api_key)
      self['destroyed'] = true
      @subid
    end

    def destroyed?
      !!self['destroyed']
    end

    def self.create!(config)
      self.validate_config(config)
      self.exec_create
    end

    def self.show_servers(account)
      servers = Agent.fetch_server_list(account.config.api_key)
      servers = servers.map do |subid, attributes|
        self.new(subid, account, attributes)
      end
    end

    private
    def self.exec_create
      subid_hash = Agent.post_create(@option)
      self.new(subid_hash['SUBID'].to_i)
    end

    def self.validate_config(config)
      plans = Agent.plans_list
      plans = plans.select{|key,value| config.plan == value['name'] }

      raise if not plans.size == 1

      regions = Agent.fetch_all_regions
      regions = regions.select{|key,value| config.region.to_s == value['name'].downcase }

      raise if not regions.keys.size == 1

      oss = Agent.fetch_all_oss
      oss = oss.select{|key,value| config.os == value['name'] }

      raise if not oss.keys.size == 1

      dcid = regions.keys.first
      available_plans = Agent.fetch_availability(dcid).map(&:to_i)

      raise if not available_plans.include?(plans.keys.first.to_i)

      @option = {
        VPSPLANID:    plans.keys.first.to_i,
        DCID:  dcid.to_i,
        OSID:      oss.keys.first.to_i,
        api_key: config.api_key,
      }

      if config.ipxe_chain_url
        @option[:ipxe_chain_url] = config.ipxe_chain_url
      end
    end
  end
end
