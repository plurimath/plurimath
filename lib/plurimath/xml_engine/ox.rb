# frozen_string_literal: true

require "plurimath/xml_engine"
require "plurimath/xml_engine/ox/comment"
require "plurimath/xml_engine/ox/element"
require "plurimath/xml_engine/ox/wrapper"
require "plurimath/xml_engine/ox/dumper"
require "plurimath/xml_engine/ox/node"
require "ox"
Ox.default_options = { encoding: "UTF-8" }

module Plurimath
  module XMLEngine
    class Ox
      class << self
        def new_element(name)
          Element.new(name)
        end

        def dump(data, **options)
          Dumper.new(data, **options).dump
        end

        def load(data)
          Element.new(
            ::Ox.load(data, strip_namespace: true),
          )
        end

        def is_xml_comment?(node)
          node.is_a?(::Ox::Comment)
        end

        def replace_nodes(root, nodes)
          root.nodes.replace(Array(nodes))
          root
        end
      end
    end
  end
end
