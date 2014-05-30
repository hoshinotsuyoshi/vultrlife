require 'json'
require 'net/https'

module Vultrlife
  module Agent
    API_HOST = 'https://api.vultr.com'
    def self.fetch_all_plans
      #/v1/plans/list
      #GET - public

      response = ''
      endpoint = '/v1/plans/list'
      uri = URI.parse("#{API_HOST}#{endpoint}")
      https = Net::HTTP.new(uri.host, 443)
      https.use_ssl = true
      https.start{|https|
        response = https.get(uri.path)
      }

      JSON.parse(response.body)
    end

    def self.fetch_all_regions
      #/v1/regions/list
      #GET - public

      response = ''
      endpoint = '/v1/regions/list'
      uri = URI.parse("#{API_HOST}#{endpoint}")
      https = Net::HTTP.new(uri.host, 443)
      https.use_ssl = true
      https.start{|https|
        response = https.get(uri.path)
      }

      JSON.parse(response.body)
    end

    def self.fetch_all_oss
      #/v1/os/list
      #GET - public

      response = ''
      endpoint = '/v1/os/list'
      uri = URI.parse("#{API_HOST}#{endpoint}")
      https = Net::HTTP.new(uri.host, 443)
      https.use_ssl = true
      https.start{|https|
        response = https.get(uri.path)
      }

      JSON.parse(response.body)
    end

    def self.fetch_availability(dcid)
      #/v1/regions/availability
      #GET - public

      response = ''
      endpoint = "/v1/regions/availability"
      uri = URI.parse("#{API_HOST}#{endpoint}")
      https = Net::HTTP.new(uri.host, 443)
      https.use_ssl = true
      https.start{|https|
        response = https.get(uri.path + "?DCID=#{dcid}")
      }

      JSON.parse(response.body).map(&:to_s)
    end

    def self.fetch_server_list(api_key)
      #/v1/server/list
      #GET - account

      response = ''
      endpoint = "/v1/server/list"
      uri = URI.parse("#{API_HOST}#{endpoint}")
      https = Net::HTTP.new(uri.host, 443)
      https.use_ssl = true
      https.start{|https|
        response = https.get(uri.path + "?api_key=#{api_key}")
      }

      JSON.parse(response.body)
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
