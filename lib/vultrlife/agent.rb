require 'open-uri'
require 'json'

module Vultrlife
  module Agent
    API_HOST = 'https://api.vultr.com'
    def self.fetch_all_plans
      #/v1/plans/list
      #GET - public

      endpoint = '/v1/plans/list'
      json = open("#{API_HOST}#{endpoint}").read
      JSON.parse json
    end

    def self.fetch_all_regions
      #/v1/regions/list
      #GET - public

      endpoint = '/v1/regions/list'
      json = open("#{API_HOST}#{endpoint}").read
      JSON.parse json
    end

    def self.fetch_availability(dcid)
      #/v1/regions/availability
      #GET - public

      endpoint = "/v1/regions/availability?DCID=#{dcid}"
      json = open("#{API_HOST}#{endpoint}").read
      JSON.parse(json).map(&:to_s)
    end

    def self.post_create(config)
      #/v1/server/create
      #POST - account
      #Create a new virtual machine. You will start being billed for this immediately. The response only contains the SUBID for the new machine. You should use v1/server/list to poll and wait for the machine to be created (as this does not happen instantly).
      #
      #Example Request:
      #POST https://api.vultr.com/v1/server/create?api_key=APIKEY
      #DCID=1
      #VPSPLANID=1
      #OSID=127
      #Example Response:
      #{
      #"SUBID": "1312965"
      #}
      #Parameters:
      #DCID integer Location to create this virtual machine in.  See v1/regions/list
      #VPSPLANID integer Plan to use when creating this virtual machine.  See v1/plans/list
      #OSID integer Operating system to use.  See v1/os/list
      #ipxe_chain_url string (optional) If you've selected the 'custom' operating system, this can be set to chainload the specified URL on bootup, via iPXE
    end
  end
end
