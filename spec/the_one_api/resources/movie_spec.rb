# frozen_string_literal: true

require "the_one_api/resources/movie"

# rubocop:disable Metrics/BlockLength
RSpec.describe TheOneApi::Movie do
  let(:client) { TheOneApi::Client.new(ENV["THE_ONE_API_KEY"]) }

  context "list all movies", vcr: { cassette_name: "list_movies" } do
    it "lists movies" do
      results = client.movie.list

      expect(results).to_not be_empty
      expect(results).to all(be_an_instance_of(TheOneApi::Movie))
    end

    it "makes properties available as methods with camel case names" do
      results = client.movie.list

      expect(results[0].runtime_in_minutes).to be_an(Integer)
    end
  end

  context "find one movie" do
    it "finds one movie", vcr: { cassette_name: "find_one_movie" } do
      result = client.movie.find("5cd95395de30eff6ebccde57")

      expect(result).to be_an_instance_of(TheOneApi::Movie)
    end

    it "makes properties available as methods with camel case names", vcr: { cassette_name: "find_one_movie" } do
      result = client.movie.find("5cd95395de30eff6ebccde57")

      expect(result.runtime_in_minutes).to be_an(Integer)
    end

    it "throws an exception if the movie can't be found", vcr: { cassette_name: "movie_doesnt_exist" } do
      expect { client.movie.find("id_doesnt_exist") }.to raise_error(TheOneApi::HttpResponseError) do |error|
        expect(error.status).not_to eq(400)
        expect(error.message).to eq("Something went wrong.")
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
