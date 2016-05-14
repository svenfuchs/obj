# Obj

A Struct replacement that allows default arguments, and omits the
hash-style API that Struct implements.

## Installation

```
gem install ruby-obj
```

## Usage

```ruby
class One < Obj.new(:one, two: :default)
end

obj = One.new(1)
obj.one  # => 1
obj.one? # => true
obj.two  # => :default
obj.two? # => true

obj = One.new(nil)
obj.one? # => false
```

Modules included to `Obj` are propagated to all instances:

```ruby
module Foo
  def foo
  end
end

Obj.include(Foo)

class One < Obj.new(:one)
end

one = One.new(1)
one.respond_to?(:foo) # => true
```

# Benchmark

`Obj` is marginally slower than `Struct` (which is implemented in C):

```ruby
require 'benchmark'
require 'obj'

n = 1_000_000

str = Struct.new(:foo)
obj = Obj.new(:foo)

Benchmark.bm(10) do |b|
  b.report('str:') { n.times { str.new(:foo).foo } }
  b.report('obj:') { n.times { obj.new(:foo).foo } }
end
```

```
                 user     system      total        real
str:         0.180000   0.000000   0.180000 (  0.174254)
obj:         0.180000   0.000000   0.180000 (  0.181985)
```
