# frozen_string_literal: true

require "flexirest"

module TheOneApi
  # Helper class to implement and wire in the response
  # transformations needed by BaseResource (see below)
  class BaseResourceProxy < Flexirest::ProxyBase
    get(+".+") do
      if @request.method[:method] == :get
        # if this is a GET request to list multiple items
        if @request.method[:name].match? "list"
          response = passthrough
          translate(response) do |body|
            # give back the array of returned entities instead of the envelope
            # structure that surrounds it
            body["docs"] || body
          end
        # if this is a GET request to a single resource by id
        elsif @request.method[:name].match? "find"
          response = passthrough
          translate(response) do |body|
            # give back the entity instead of an array of one entity
            body["docs"] && body["docs"][0] ? body["docs"][0] : body
          end
        end
      end
    end
  end

  # Common functionality for all API resources, including:
  #   + Adding authentication header
  #   + Unwrapping the `docs` array
  #       when listing multiple items from a resource
  #   + Unwrapping the one item returned in the `docs` array
  #       when requesting a single entity by id
  class BaseResource < Flexirest::Base
    proxy BaseResourceProxy

    before_request :add_authentication_header
    after_request :handle_http_error

    private

    def add_authentication_header(_name, request)
      return unless request.get_params[:api_key]

      request.headers["Authorization"] = "Bearer #{request.get_params[:api_key]}"
      request.get_params.delete(:api_key)
    end

    def handle_http_error(_name, response)
      return unless response.status && response.status != 200

      raise HttpResponseError.new(response.status,
                                  response.body["message"])
    end
  end
end
