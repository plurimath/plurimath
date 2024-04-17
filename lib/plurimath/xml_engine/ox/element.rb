require "ox/hasattrs"
require "ox/element"

module Plurimath
  module XMLEngine
    class Ox
      class Element < ::Ox::Element
        def set_attr(attrs)
          @attributes = attrs&.to_h
        end

        def <<(object)
          super(object)
        end
      end
    end
  end
end
