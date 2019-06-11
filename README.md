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
    # => #<HpSqrt:0x00003ff699526258 value=(1.4142135623730951+0.0i) expr=(√2)> 
    
    p Sqrt(2).to_f
    #  => 1.4142135623730951
    
    p (Sqrt(2) ** 2).to_f
    #  => 2.0 
    
    p (Sqrt(3) * Sqrt(5) * Sqrt(15)).to_f
    #  => 15.0 
    
    p (Sqrt(1i) ** 4).to_c
    #  => (-1.0+0.0i) 
    
    p ((Sqrt(7) + Sqrt(11)) * (Sqrt(7) - Sqrt(11))).to_f
    #  => -4.0 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yoshida-eth0/ruby-sqrt.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
