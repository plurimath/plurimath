# frozen_string_literal: true

require "plurimath/xml_engine"
require "plurimath/xml_engine/ox_engine/element"
require "ox"
Ox.default_options = { encoding: "UTF-8" }

module Plurimath
  module XmlEngine
    class OxEngine
      class << self
        def new_element(name)
          Element.new(name)
        end

        def dump(data, **options)
          ::Ox.dump(data.xml_nodes, **options)
        end

        def load(data)
          Element.new(
            ::Ox.load(data, strip_namespace: true),
          )
        end

        def is_xml_comment?(node)
          return node.is_xml_comment? if node.is_a?(Element)

          false
        end

        def replace_nodes(root, nodes)
          root.replace_nodes(Array(nodes))
          root
        end
      end
    end
  end
end
