require "rest-client"
require "json"

module Freshservice
  class Resource
    def initialize(endpoint, params = {}, id = nil)
      @endpoint             = endpoint
      @params               = params
      @id                   = id
      @domain               = Freshservice.domain
      @user_name_or_api_key = Freshservice.user_name_or_api_key
      @password_or_x        = Freshservice.password_or_x
      @api_version          = Freshservice.api_version

      @resource ||= RestClient::Resource.new(
        api_url,
        @user_name_or_api_key,
        @password_or_x
      )
    end

    attr_reader :endpoint, :params

    def api_url
      "https://#{@domain}.freshservice.com/api/#{@api_version}#{@endpoint}"
    end

    def json_payload
      @params.to_json
    end

    def post
      @resource.post(json_payload, content_type: "application/json")
    rescue RestClient::Exception => e
      raise e, api_error_message(e)
    end

    def get
      @resource.get(accept: "application/json")
    rescue RestClient::Exception => e
      raise e, api_error_message(e)
    end

    def delete
      @resource.delete(accept: "application/json")
    rescue RestClient::Exception => e
      raise e, api_error_message(e)
    end

    def put
      @resource.put(json_payload, content_type: "application/json")
    rescue RestClient::Exception => e
      raise e, api_error_message(e)
    end

    private

    def api_error_message(e)
      "API Error: Your request is not successful." \
      "If you are not able to debug this error properly, mail us at support@freshservice.com with the follwing X-Request-Id" \
      "X-Request-Id : #{e.response.headers[:x_request_id]}" \
      "Response Code: #{e.response.code} Response Body: #{e.response.body}"
    end
  end
end
