require "ox/node"

module Plurimath
  module XMLEngine
    class Ox
      class Node < ::Ox::Node
        def comment?
          false
        end
      end
    end
  end
end
