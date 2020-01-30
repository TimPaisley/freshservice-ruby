module Freshservice
  class FreshserviceObject
    def initialize(endpoint)
      @endpoint = endpoint
    end

    attr_reader :endpoint

    def resource(params: {}, id: nil)
      Freshservice::Resource.new(endpoint, params, id)
    end
  end
end
