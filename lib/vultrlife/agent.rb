require 'json'
require 'net/https'

module Vultrlife
  module Agent
    API_HOST = 'https://api.vultr.com'

    def self.query(option)
      return '' if option.empty?
      '?' + option.map{|e| e.join '='}.join('&')
    end

    def self.http_get(endpoint, params={})
      response = ''

      uri = URI.parse("#{API_HOST}#{endpoint}")
      https = Net::HTTP.new(uri.host, 443)
      https.use_ssl = true
      https.start{|https|
        response = https.get(uri.path + query(params))
      }

      JSON.parse(response.body)
    end

    def self.fetch_all_plans
      #/v1/plans/list
      #GET - public

      self.http_get('/v1/plans/list')
    end

    def self.fetch_all_regions
      #/v1/regions/list
      #GET - public

      self.http_get('/v1/regions/list')
    end

    def self.fetch_all_oss
      #/v1/os/list
      #GET - public

      self.http_get('/v1/os/list')
    end

    def self.fetch_availability(dcid)
      #/v1/regions/availability
      #GET - public

      self.http_get('/v1/regions/availability', DCID: dcid)
      .map(&:to_s)
    end

    def self.fetch_server_list(api_key)
      #/v1/server/list
      #GET - account

      self.http_get('/v1/server/list', api_key: api_key)
    end

    def self.post_create(option)
      #/v1/server/create
      #POST - account

      endpoint = "/v1/server/create"

      body =  "DCID=#{option[:region]}"
      body << "&VPSPLANID=#{option[:plan]}"
      body << "&OSID=#{option[:os]}"
      if option[:ipxe_chain_url]
        body << "&ipxe_chain_url=#{option[:ipxe_chain_url]}"
      end
      response = ''

      uri = URI.parse("#{API_HOST}#{endpoint}")
      https = Net::HTTP.new(uri.host, 443)
      https.use_ssl = true
      https.start{|https|
        https.verify_mode = OpenSSL::SSL::VERIFY_PEER
        header = {}
        response = https.post(uri.path + "?api_key=#{option[:api_key]}", body, header)
      }

      JSON.parse(response.body)
    end

    def self.post_destroy(option)
      #/v1/server/destroy
      #POST - account

      endpoint = "/v1/server/destroy"

      body =  "SUBID=#{option[:subid]}"
      response = ''

      uri = URI.parse("#{API_HOST}#{endpoint}")
      https = Net::HTTP.new(uri.host, 443)
      https.use_ssl = true
      https.start{|https|
        https.verify_mode = OpenSSL::SSL::VERIFY_PEER
        header = {}
        response = https.post(uri.path + "?api_key=#{option[:api_key]}", body, header)
      }

      if response.body.nil? && response.code == '200'
        ''
      else
        JSON.parse(response.body)
      end
    end
  end
end
