module Plurimath
  module XMLEngine
    class Ox
      class Dumper
        def initialize(data, **options)
          @data = data
          @options = options
        end

        def dump
          @data.dumper
        end
      end
    end
  end
end
