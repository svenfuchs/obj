# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'obj/version'

Gem::Specification.new do |s|
  s.name          = 'ruby-obj'
  s.version       = Obj::VERSION
  s.authors       = ['Sven Fuchs']
  s.email         = ['me@svenfuchs.com']
  s.homepage      = 'https://github.com/svenfuchs/obj'
  s.licenses      = ['MIT']
  s.summary       = 'Struct replacement with argument defaults'
  s.description   = 'Struct replacement with argument defaults.'

  s.files         = Dir.glob('{bin/*,lib/**/*,[A-Z]*}')
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
end
