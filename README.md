# cache_if_slow

[![Gem Version](https://badge.fury.io/rb/cache_if_slow.png)](https://badge.fury.io/rb/cache_if_slow)
[![CI Status](https://github.com/cianmce/cache_if_slow/actions/workflows/main.yml/badge.svg)](https://github.com/cianmce/cache_if_slow/actions)

Caches slow blocks of code using a cascading configuration.

## Installation

### Add gem

Add this line to your application's Gemfile:

```ruby
gem 'cache_if_slow'
```

And then execute:

    $ bundle install

Or install it yourself:

    $ gem install cache_if_slow

## Usage

### Create cache instance

`expiry_lookup` can be used to set the ttl for a given block of code.

With the below example, if a block of code took 1 -> 5 seconds, e.g. 2 seconds, then that result will be cached for 10 minutes. If it instead took over 10 seconds, then it would be cached for 30 minutes.

```ruby
def self.cache
  @cache ||= CacheIfSlow.new(expiry_lookup: [
    { slower_than: 1.second, expires_in: 10.minutes },
    { slower_than: 5.seconds, expires_in: 20.minutes },
    { slower_than: 10.seconds, expires_in: 30.minutes }
  ])
end
```

### `fetch` the result

This operates as a proxy to the [`Rails.cache.fetch`](https://apidock.com/rails/ActiveSupport/Cache/Store/fetch) method.

```ruby
returned_value = self.class.cache.fetch("unique-cache-key") do
  slow_request()
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Testing
#### Run all specs + standardrb

```sh
bundle exec rake
```

#### Run only standardrb

```sh
bundle exec rake standard
````

#### Apply standardrb auto fixes

```sh
bundle exec rake standard:fix
```

#### Run specs using guard

```sh
bundle exec guard
```

This will auto run the related unit tests while you develop and save files.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cianmce/cache_if_slow. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/cianmce/cache_if_slow/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the cache_if_slow project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/cianmce/cache_if_slow/blob/master/CODE_OF_CONDUCT.md).

## TODO

- [ ] Update Readme and spec with class method examples

