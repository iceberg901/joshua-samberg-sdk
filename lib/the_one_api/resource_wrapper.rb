# frozen_string_literal: true

module TheOneApi
  # A client for The One Api
  class ResourceWrapper
    def initialize(wrapped_resource, api_key)
      @wrapped_resource = wrapped_resource
      @api_key = api_key
    end

    def method_missing(method, *args, &block)
      super unless @wrapped_resource._calls.key?(method)

      # merge the api key in with the supplied
      # arguments so that the request can be authenticated
      args_with_api_key = if args[0].is_a?(Hash)
                            (args[0]).merge({ api_key: @api_key })
                          elsif args[0]
                            { id: args[0] }.merge({ api_key: @api_key })
                          else
                            { api_key: @api_key }
                          end

      @wrapped_resource.send(method, args_with_api_key, &block)
    end

    def respond_to_missing?(method, include_private = false)
      @wrapped_resource._calls.key?(method) || super
    end
  end
end
