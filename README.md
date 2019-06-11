# HpSqrt

High precision square root library for Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hpsqrt'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hpsqrt

## Usage

    require 'hpsqrt/core_ext'
    
    p Sqrt(2)
    #  => 1.4142135623730951+0.0i
    
    p Sqrt(2) ** 2
    #  => 2.0+0.0i
    
    p Sqrt(3) * Sqrt(5) * Sqrt(15)
    #  => 15.0+0.0i
    
    p Sqrt(1i) ** 4
    #  => -1.0+0.0i
    
    p (Sqrt(7) + Sqrt(11)) * (Sqrt(7) - Sqrt(11))
    #  => -4.0+0.0i

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yoshida-eth0/ruby-sqrt.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
