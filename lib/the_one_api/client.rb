# frozen_string_literal: true

require "the_one_api/resource_wrapper"
require "the_one_api/resources/movie"

module TheOneApi
  # A client for The One Api
  class Client
    BASE_URL = "https://the-one-api.dev/v2/"

    Flexirest::Base.base_url = BASE_URL
    Flexirest::Base.faraday_config do |faraday|
      faraday.adapter(:net_http)
    end

    def initialize(api_key)
      @api_key = api_key
    end

    def movie
      @movie ||= ResourceWrapper.new(Movie, @api_key)
    end
  end
end
