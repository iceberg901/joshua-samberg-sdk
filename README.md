# TheOneApi

This is a Ruby gem that provides an SDK for interacting with [The One API](https://the-one-api.dev/)

## Installation

You don't need this source code unless you want to modify the gem. If you just want to use the package, just run:

    $ gem install the_one_api


If you want to build the gem from source:

    $ gem build the_one_api

### Installing with Bundler

Install the gem and add to the application's Gemfile by executing:

    $ bundle add the_one_api

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

Query nested API resources (e.g. `/movie/{id}/quotes`) through method on the client named for the kind of entity you want to retrieve chained with a method using the `list_for_` naming convetion:

```ruby
require 'the_one_api'

client = TheOneApi::Client.new("your-API-key")

quotes = client.quote.list_for_movie("5cd95395de30eff6ebccde5b")
quotes.size
#=> 1000
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

### Currently Supported Endpoints/Operations

| Endpoint            | SDK Entry Point                                | Operation                               |
| ------------------- | ---------------------------------------------- | --------------------------------------- |
| `/movie`            | `TheOneApi::Client.movie.list`                 | list all movies                         |
| `/movie/{id}`       | `TheOneApi::Client.movie.find({id})`           | find a movie by id                      |
| `/movie/{id}/quote` | `TheOneApi::Client.quote.list_for_movie({id})` | list all quotes from a particular movie |
| `/quote`            | `TheOneApi::Client.quote.list`                 | list all quotes                         |
| `/quote/{id}`       | `TheOneApi::Client.quote.find({id}`            | find a quote by id                      |

### Currently Unsupported Features

The SDK currently does not explicitly support
+ endpoints not listed above
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
