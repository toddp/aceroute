# Aceroute

This gem implements the [Aceroute API](http://aceroute.com)

Aceroute is a SaaS application for field management. Aceroute allows you to
schedule customer visits, optimize driving routes and more.


This library is still very early and very much under development.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aceroute'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aceroute

## Usage

First set the ACEROUTE_API_TOKEN environment variable to contain your Aceroute
api key:

    export ACEROUTE_API_TOKEN=mytoken


See the documentation on [Aceroute classes and  methods](http://toddp.github.io/aceroute/) for which ones you can call.

There are classes corrsponding to each entity in the Aceroute API, such as Customer, Location, and Order. So far these 3 are the only supported entities, others will be added as needed.

You can create a new entity by instantiating it with .new(), but it will only be persisted to the Aceroute API when you call .create!  See Customer class for an example.

Likewise, you can delete any instance by calling .destroy! . Alternatively, you can call the class method .delete(id) and passing any valid Aceroute id for that type of object, e.g. a Customer id.




## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/aceroute/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request



## License
This gem is available on [github](https://github.com/toddp/aceroute) under an [MIT License](http://revolunet.mit-license.org/).
