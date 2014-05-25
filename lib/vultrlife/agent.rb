require 'open-uri'
require 'json'
require 'net/https'

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

    def self.fetch_server_list(api_key)
      #/v1/server/list
      #GET - account

      endpoint = "/v1/server/list?api_key=#{api_key}"
      json = open("#{API_HOST}#{endpoint}").read
      JSON.parse json
    end

    def self.post_create(option)
      #/v1/server/create
      #POST - account

      endpoint = "/v1/server/create"

      body =  "DCID=#{option[:region]}"
      body << "&VPSPLANID=#{option[:plan]}"
      body << "&OSID=#{option[:os]}"
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

      JSON.parse(response.body)
    end
  end
end
