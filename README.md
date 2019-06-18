[![Build Status](https://travis-ci.org/yoshida-eth0/ruby-sqrt.svg?branch=master)](https://travis-ci.org/yoshida-eth0/ruby-sqrt)
[![Gem Version](https://badge.fury.io/rb/hpsqrt.svg)](https://badge.fury.io/rb/hpsqrt)

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

High precision calculation:

```ruby
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
```

Support operators:

    +, -, *, /, %, **, ==, <=>

Type casting:

```ruby
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

# to Complex (involving Rational)
p (Sqrt(2)**2).to_rc
#  => ((2/1)+(0/1)*i)

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
```

Type check:

```ruby
require 'hpsqrt/core_ext'

# integer? returns true if after the real decimal point is 0 and imaginary number is 0
p Sqrt(2).integer?
#  => false
p Sqrt(4).integer?
#  => true

# float? returns true if after the real decimal point is not 0 and imaginary number is 0
p Sqrt(2).float?
#  => true
p Sqrt(4).float?
#  => false

# complex? returns true if imaginary number is not 0
p Sqrt(1).complex?
#  => false
p Sqrt(-1).complex?
#  => true
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yoshida-eth0/ruby-sqrt.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
