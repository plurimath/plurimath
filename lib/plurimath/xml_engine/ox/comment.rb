require "ox/node"

module Plurimath
  module XMLEngine
    class Ox
      class Comment < ::Ox::Node
        def comment?
          true
        end
      end
    end
  end
end
