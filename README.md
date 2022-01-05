# ResourceStruct

![Continous Integration](https://github.com/AlexRiedler/resource-struct/actions/workflows/default.yml/badge.svg)

This is a gem for working with JSON resources from a network source with indifferent and method based access.

Instead of overriding Hash implementation, this wraps a Hash with indifferent access (by symbol or string keys).
This makes it fast at runtime, while still providing the necessary lookup method of choice.

There are two immutable types `ResouceStruct::FirmStruct` and `ResourceStruct::LooseStruct`.

`ResourceStruct::FirmStruct` provides a way of wrapping a Hash such that accesses to invalid keys will raise an exception through the method lookup method.

`ResouceStruct::LooseStruct` provides a way of wrapping a Hash such that it returns nil instead of raising an exception when the key is not present in the hash.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'resource-struct'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install resource-struct

## Usage

### FirmStruct

```ruby
struct = ResourceStruct::FirmStruct.new({ "foo" => 1, "bar" => [{ "baz" => 2 }, 3] })
struct.foo? # => true
struct.brr? # => false
struct.foo # => 1
struct.bar # => [FirmStruct<{ "baz" => 2 }>, 3]
struct.brr # => NoMethodError
struct[:foo] # => 1
struct[:brr] # => nil
struct[:bar, 0, :baz] # => 2
struct[:bar, 0, :brr] # => nil
```

### LooseStruct

```ruby
struct = ResourceStruct::LooseStruct.new({ "foo" => 1, "bar" => [{ "baz" => 2 }, 3] })

struct.foo? # => true
struct.brr? # => false
struct.foo # => 1
struct.bar # => [LooseStruct<{ "baz" => 2 }>, 3]
struct.brr # => nil
struct[:foo] # => 1
struct[:brr] # => nil
struct[:bar, 0, :baz] # => 2
struct[:bar, 0, :brr] # => nil
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/resource-struct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
