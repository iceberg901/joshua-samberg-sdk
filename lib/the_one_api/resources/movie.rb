# frozen_string_literal: true

require "the_one_api/resources/base_resource"

module TheOneApi
  # Resource definition for Movies
  class Movie < BaseResource
    get :list, "/movie", rubify_names: true
    get :find, "/movie/:id", rubify_names: true
  end
end
