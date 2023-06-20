# frozen_string_literal: true

require "the_one_api/resources/base_resource"

module TheOneApi
  # Resource definition for Quotes
  class Quote < BaseResource
    get :list, "/quote", rubify_names: true
    get :find, "/quote/:id", rubify_names: true
    get :list_for_movie, "/movie/:id/quote", rubify_names: true
  end
end
