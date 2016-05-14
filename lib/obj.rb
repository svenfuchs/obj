# frozen_string_literal: true
class Obj
  class << self
    def include(*modules)
      super
      includes.concat(modules)
    end

    def includes
      @includes ||= []
    end

    def new(*attrs, &block)
      defaults = attrs.last.is_a?(Hash) ? attrs.pop : {}

      Class.new do
        include *Obj.includes if Obj.includes.any?

        args = attrs + defaults.map(&->(pair) { '%s = %p' % pair })
        init = attrs.map(&->(name) { '@%s = %s' % [name, name] })
        init = init + defaults.map(&->(pair) { '@%s = %s || %p' % [pair.first, *pair] })

        class_eval %(
          def initialize(#{args.join(', ')})
            #{init.join("\n")}
          end
        )

        attrs.concat(defaults.keys).each do |attr|
          attr_accessor *attr
          define_method(:"#{attr}?") { !!send(attr) }
        end

        class_eval &block if block
      end
    end
  end
end
