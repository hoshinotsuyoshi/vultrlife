require 'json'
require 'net/https'

module Vultrlife
  module Agent
    API_HOST = 'https://api.vultr.com'

    # GET

    def self.http_get(endpoint, params={})
      response = ''

      uri = URI.parse("#{API_HOST}#{endpoint}")
      https = Net::HTTP.new(uri.host, 443)
      https.use_ssl = true
      https.start{|https|
        response = https.get(uri.path + '?'+ query(params))
      }

      if response.body.to_s.empty?
        ''
      else
        JSON.parse(response.body)
      end
    end

    def self.plans_list
      #/v1/plans/list
      #GET - public

      self.http_get('/v1/plans/list')
    end

    def self.regions_list
      #/v1/regions/list
      #GET - public

      self.http_get('/v1/regions/list')
    end

    def self.os_list
      #/v1/os/list
      #GET - public

      self.http_get('/v1/os/list')
    end

    def self.regions_availability(dcid)
      #/v1/regions/availability
      #GET - public

      self.http_get('/v1/regions/availability', DCID: dcid.to_s)
      .map(&:to_s)
    end

    def self.server_list(api_key)
      #/v1/server/list
      #GET - account

      self.http_get('/v1/server/list', api_key: api_key)
    end

    # POST

    def self.http_post(endpoint, body)
      response = ''

      api_key = body.delete(:api_key)

      uri = URI.parse("#{API_HOST}#{endpoint}")
      https = Net::HTTP.new(uri.host, 443)
      https.use_ssl = true
      https.start{|https|
        response = https.post("#{uri.path}?api_key=#{api_key}",query(body))
      }

      if response.body.to_s.empty?
        ''
      else
        JSON.parse(response.body)
      end
    end

    def self.server_create(body)
      #/v1/server/create
      #POST - account

      self.http_post('/v1/server/create', body)
    end

    def self.server_destroy(body)
      #/v1/server/destroy
      #POST - account

      self.http_post('/v1/server/destroy', body)
    end

    # helper

    def self.query(option)
      return '' if option.empty?
      option.map{|e| e.join '='}.join('&')
    end
  end
end
