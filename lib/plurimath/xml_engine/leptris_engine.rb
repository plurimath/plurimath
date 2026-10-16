# frozen_string_literal: true

require "leptris"

module Plurimath
  module XmlEngine
    class LeptrisEngine
      class << self
        def new_element(name)
          Element.new(name)
        end

        def dump(data, indent: nil)
          # ox dump parity: compact when indent is nil, 2-space pretty print
          # otherwise; ox additionally wraps the output in newlines — the
          # leading one is stripped by REPLACABLES downstream, the trailing
          # one is part of the expected output, so it is appended here.
          xml = data.xml_nodes.to_xml(indent: indent)
          indent ? "#{xml}\n" : xml
        end

        def load(data)
          Element.new(::Leptris::XML.parse(data), strip_prefix: true)
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

      autoload :Element, "#{__dir__}/leptris_engine/element"
    end
  end
end
