module Plurimath
  module XmlEngine
    class Oga
      # Create API compatible with Ox, per Plurimath usage
      class Wrapper
        def initialize(value)
          @wrapped = value
        end

        def unwrap
          @wrapped
        end

        def ==(other)
          self.class == other.class &&
            @wrapped.inspect == other.unwrap.inspect
        end
      end
    end
  end
end
