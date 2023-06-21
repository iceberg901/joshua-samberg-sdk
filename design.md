# TheOneApi Design Notes

This document records and explains the software design of `the_one_api` Ruby gem and codebase.

## Overview

### Single Entry Point - `TheOneAPI::Client`

All use of the SDK and the underlying REST API goes through a single entry point: an instance of `TheOneAPI::Client`. So, for example, to get access to the `/movie` endpoint, we use the `movie` member of `TheOneAPI::Client`:

```ruby
require 'the_one_api'

client = TheOneApi::Client.new("your-API-key")
movies = client.movie.list
```

#### Benefits
+ Good encapsulation - we don't expose internals of our library to clients, since anything they will use needs to be explicitly added to the interface of `TheOneAPI::Client`
+ Easier maintenance - we don't have to keep adding `require` lines to `the_one_api.rb`, with correct folder names, every time we add new functionality

### Property Access Through Named Methods

A main goal of this SDK is to make access of data from the REST API more safe and convenient than working with the underlying JSON.

Therefore, properties of API entities are accessed through named methods of the form `entity.property_name`. 

**NB:** Snake casing is the standard in Ruby, so a REST API that returns `{"entity": {"propertyName" : "value"}}` in JSON will have that property name automatically converted to a method with the snake-cased name `property_name` to make things intuitive and comfortable for Ruby developers.

👍 Ideally, developers won't have to do this:

```ruby
quote["dialog"]
```

and then surprisingly fail much later because they misspelled `dialog` or because the API didn't return that field.

👍 Instead, developers can do this:

```ruby
quote.dialog
```

and ideally fail immediately if they made some mistake in the syntax or the data doesn't match key expectations.

Future enhancements to these named property methods that could make them even safer and more convenient are [discussed later](#autocomplete-able-chainable-property-names).

### Dependency: `flexirest`

The SDK uses the `flexirest` gem internally.

With the time constraints of the initial implementation, I wanted to use a 3rd party library to abstract and simplify repetitive elements that I knew I would otherwise have to take a long time building and refactoring, such as:

+ Mapping method calls to the right API paths
+ Handling the request/response cycle
+ Validating and wrapping JSON responses into Ruby objects
+ Configuration

#### Selection Process

Here is a summary of the 3rd party libraries evaluated and the basis for choosing `flexirest`.

+ ✅ `flexirest` - [https://github.com/flexirest/flexirest](https://github.com/flexirest/flexirest)
    + 👍 Expressive DSL and easy to get started with
    + 👍 Full-featured, supports many things we needed out of the box
        + Especially, supports automatic generation of [named property methods](#property-access-through-named-methods) with snake casing
    + 👍 Easy to bring in only the capabilities and methods from the library that we want to use
    + 👎 Configuration is global
+ ❌ `api_struct` - [https://github.com/rubygarage/api_struct](https://github.com/rubygarage/api_struct)
    + 👍 Compact, expressive DSL, and easy to get started with
    + 👎 Missing key capabilites that we need
        + Does not provide the validation and wrapping of JSON into Ruby objects
        + Does not provide access through [named property methods](#property-access-through-named-methods)
+ ❌ `activeresource` - [https://github.com/rails/activeresource](https://github.com/rails/activeresource)
    + 👎 Too specific to working with `rails`
    + 👎 Not easy to bring in only the capabilities and methods from the library that we want to use
        + For example, if we use it to map a `get` request for `TheOneApi::Movie` it will also map all the other request verbs and create methods accessible to clients of our SDK that we don't want to expose

#### Benefits
+ Don't have to reinvent the wheel
+ Got the project bootstrapped fast and finished in time
+ Can rely on decisions and best practices of the library writers for situations that likely arise in many projects like this one
    + Focus our big decisions and complex implementations on the unique needs of our particular SDK
+ Code is compact, readable, and follows conventions that are already documented in the 3rd party library's documentation

#### Drawbacks
+ Maintenance Risk
    + When the library is updated we may need to make changes
    + If the library is not well or continuously maintained, we may need to fork or replace it some day
+ Technical Debt
    + Need to make some hacks around the 3rd party library where it doesn't make it easy to do exactly what we want
    + Eventually we may have created too many of these hacks
        * Then, we may need to pay back the debt by modifying the library or rolling our own solution

## Potential Improvements

This section records ideas for potential future improvements to the design and functionality of the library.

### Nested resources accessible from parent entities

Currently the library requires a one-to-one mapping of REST API endpoints to class methods on classes inheriting `TheOneApi::BaseResource`. 

👎 That requires the following style of access for a nested resource like `/movie/{id}/quote`:

```ruby
require 'the_one_api'

client = TheOneApi::Client.new("your-API-key")

### get the id for a movie of interest
movies = client.movie.list
movie_id = movies[0]._id

### get the quotes for that movie
client.quote.list_for_movie(movie._id)
```

👍 In the future, we would implement a more natural style that would look like this:

```ruby
require 'the_one_api'

client = TheOneApi::Client.new("your-API-key")

### get a movie of interest
movies = client.movie.list
movie = movies[0]

### return lazy loaded quotes for that movie
movie.quotes
```

**NB:** This solution would use lazy loading so that the second API call to get the quotes wouldn't be made until the client actually used them for something.

#### Prerequisites

In order to implement this solution, we'd need to rearchitect the way we handle setting the API key. Currently, the API key is set when creating an instance of `TheOneApi::Client`. So then, when the client calls `movie.quotes` in the example above, which instance of `TheOneApi::Client` are they using to make the REST API call?

Possible solutions would be
+ Making `TheOneAPI::Client` a singleton, which would require figuring out how to allow using multuple API keys, or deprecating the ability to do so
    + 👍 This might also allow us to eliminate the need for `TheOneApi::ResourceWrapper` class that uses metaprogramming to inject the API key into the request whenever a client calls any of the mapped methods on a  class inheriting `TheOneApi::BaseResource`.
+ Holding a reference to the Client within the individual Movies that the Client returns
    + 👎 So far, this seems like a bad idea

### Autocomplete-able, Chainable Property Names

A major benefit of working with this SDK instead of making raw calls to the REST API and manipulating the JSON responses directly is the ability to use named methods to access the properties.

> 💡 These property names should be autocomplete-able in the ruby console, and should be chainable without having to check if they are `nil`.

👍 So you can ideally do this:

```ruby
movie.quotes[0].dialog
```

👎 Instead of this:
```ruby
movie && movie.quotes && movie.quotes[0] && movie.quotes[0].dialog
```

The current implementation of these named property methods comes from the `flexirest` gem and doesn't support this, so we'd need to either improve the gem, replace it, or roll our own solution.

### Functional Error Handling

The library currently raises Exceptions when encountering errors from the REST API calls it makes. This does not faciliate all of the composable, functional programming a client of the library might want to do in a language like Ruby.

A possible future solution would be for the methods that actually call the REST API to return something like a monad, perhaps using the [dry-monads](https://dry-rb.org/gems/dry-monads/1.6/) gem, as Ruby does not seem to have this capability natively.

**Pros**
+ Allows programming in a more functional style

**Cons**
+ Using an external gem for this purpose increases the dependencies of our library