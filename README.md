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

Calculation:

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

Type casting:

    require 'hpsqrt/core_ext'
    
    # to Float
    p Sqrt(5).to_f
    #  => 2.23606797749979
    
    # to Integer
    p Sqrt(5).to_i
    #  => 2
    
    # to Rational
    p Sqrt(4).to_r
    #  => (2/1)
    
    # to Complex
    p Sqrt(-1i).to_c
    #  => (0.7071067811865476-0.7071067811865476i) 
    
    # to Complex real number
    p Sqrt(-1i).real
    #  => 0.7071067811865476
    
    # to Complex imaginary number
    p Sqrt(1i).imag
    #  => -0.7071067811865476
    
    p (Sqrt(5) + Sqrt(7)).expr
    #  => "√5 + √7" 

Type check:

    require 'hpsqrt/core_ext'
    
    # real? returns true if imaginary number is 0
    p Sqrt(5).real?
    #  => true
    p Sqrt(1i).real?
    #  => false

    # imag? returns true if imaginary number is not 0
    p Sqrt(5).imag?
    #  => false
    p Sqrt(1i).imag?
    #  => true
    
    # int? return true if after the real decimal point is 0 and imaginary number is 0
    p Sqrt(2).int?
    #  => false
    p Sqrt(4).int?
    #  => true
    
    # float? return true if after the real decimal point is not 0 and imaginary number is 0
    p Sqrt(2).float?
    #  => true
    p Sqrt(4).float?
    #  => false

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yoshida-eth0/ruby-sqrt.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
