# frozen_string_literal: true

require_relative "the_one_api/version"

# Module containing everything our Gem exports
module TheOneApi
  autoload :Client, "the_one_api/client"

  autoload :HttpResponseError, "the_one_api/http_response_error"
  autoload :Error, "the_one_api/error"
end
