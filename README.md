# TheOneApi

This is a Ruby gem that provides an SDK for interacting with [The One API](https://the-one-api.dev/)

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

You don't need this source code unless you want to modify the gem. If you just want to use the package, just run:

    $ gem install UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG


If you want to build the gem from source:

    $ gem build UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

### Installing with Bundler

Install the gem and add to the application's Gemfile by executing:

    $ bundle add UPDATE_WITH_YOUR_GEM_NAME_PRIOR_TO_RELEASE_TO_RUBYGEMS_ORG

### Requirements

+ Ruby 3.0+

## Usage

Interact with [The One API](https://the-one-api.dev/) through an instance of `TheOneApi::Client`. To create one you must specify your API Key, which is required by most endpoints:

```ruby
require 'the_one_api'

# Replace "your-api-key" with your actual API key
client = TheOneApi::Client.new("your-API-key")
```

### Querying Data

Query root level API resources (e.g. `/movie`) through corresponding named methods on the client. API entities are returned as Ruby objects.

```ruby
require 'the_one_api'

client = TheOneApi::Client.new("your-API-key")

# list movies with the movie resource (the /movie endpoint)
movies = client.movie.list
movies.count
# => 8

# find one movie by its id with the movie resource (the /movie/{id} endpoint)
movie = client.movie.find("5cd95395de30eff6ebccde57")
#=> #<TheOneApi::Movie _id: "5cd95395de30eff6ebccde57", name: "The Hobbit Se..

# properties of API entites available as snake-ized named members on the returned objects
movie.runtime_in_minutes
#=> 462

```

### Errors

The client will raise `TheOneApi::HttpResponseError` when a request returns a bad status code:

```ruby
require 'the_one_api'

client = TheOneApi::Client.new("your-API-key")

begin
    client.movie.find("does_not_exist") # raises an error
rescue TheOneApi::HttpResponseError => e
    puts "Failed to find movie with id 'does_not_exist', error code: #{e.status}, error: #{e.message}"
end
```

**Note:** [The One API](https://the-one-api.dev/) DOES NOT return standard HTTP errors, for example the above example returns a `500 Internal Server Error`, not a `404 Not Found`.

## Supported API Features

### Currently Supported Root Level Endpoints/Operations

+ `/movie` - list all movies, find a movie by id

### Currently Unsupported Features

The SDK currently does not explicitly support
+ root level endpoints not listed above
+ nested endpoints - e.g. `/movie/{id}/quote`
+ Pagination, Sorting and Filtering as described [here](https://the-one-api.dev/documentation#5)

However, you can supply custom query parameters as a hash to any of the named resource methods on `TheOneApi::Client`, for example:

```ruby
require 'the_one_api'

client = TheOneApi::Client.new("your-API-key")

# this request will have special_parameter=value added to its query string
client.movie.list(special_parameter: "value")
```


## Development

After checking out the repo:
+ run `bin/setup` to install dependencies
+ run `bundle exec rake test` to run the tests
+ run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine:
+ run `bundle exec rake install`

To release a new version
+ update the version number in `version.rb`
+ run `bundle exec rake release`
    * this will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

<!-- ## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/the_one_api. -->

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
