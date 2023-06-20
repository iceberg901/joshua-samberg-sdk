# frozen_string_literal: true

require "the_one_api/resources/quote"

# rubocop:disable Metrics/BlockLength
RSpec.describe TheOneApi::Quote do
  let(:client) { TheOneApi::Client.new(ENV["THE_ONE_API_KEY"]) }

  context "list all quotes", vcr: { cassette_name: "list_quotes" } do
    it "lists quotes" do
      results = client.quote.list

      expect(results).to_not be_empty
      expect(results).to all(be_an_instance_of(TheOneApi::Quote))
    end

    it "makes properties available as methods" do
      results = client.quote.list

      expect(results[0].dialog).to be_a(String)
    end
  end

  context "find one quote" do
    it "finds one quote", vcr: { cassette_name: "find_one_quote" } do
      result = client.quote.find("5cd96e05de30eff6ebcce80b")

      expect(result).to be_an_instance_of(TheOneApi::Quote)
    end

    it "makes properties available as methods", vcr: { cassette_name: "find_one_quote" } do
      result = client.quote.find("5cd96e05de30eff6ebcce80b")

      expect(result.dialog).to be_a(String)
    end

    it "throws an exception if the quote can't be found", vcr: { cassette_name: "quote_doesnt_exist" } do
      expect { client.quote.find("id_doesnt_exist") }.to raise_error(TheOneApi::HttpResponseError) do |error|
        expect(error.status).not_to eq(400)
        expect(error.message).to eq("Something went wrong.")
      end
    end
  end

  context "list quotes for a movie", vcr: { cassette_name: "list_quotes_for_movie" } do
    it "lists quotes" do
      results = client.quote.list_for_movie("5cd95395de30eff6ebccde5b")

      expect(results).to_not be_empty
      expect(results).to all(be_an_instance_of(TheOneApi::Quote))
    end

    it "makes properties available as methods" do
      results = client.quote.list_for_movie("5cd95395de30eff6ebccde5b")

      expect(results[0].dialog).to be_a(String)
    end
  end
end
# rubocop:enable Metrics/BlockLength
