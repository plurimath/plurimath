# frozen_string_literal: true

require "plurimath/xml_engine"
require "corelib/array/pack" if RUBY_ENGINE == "opal"
require "oga"
require_relative "oga/document"
require_relative "oga/wrapper"
require_relative "oga/element"
require_relative "oga/dumper"
require_relative "oga/node"

module Plurimath
  module XmlEngine
    class Oga
      class << self
        def new_element(name)
          data = ::Oga::XML::Element.new(name: name)
          Node.new(data)
        end

        def dump(data, indent: nil)
          Dumper.new(data, indent: indent).dump.out
        end

        def load(data)
          data = ::Oga::XML::Parser.new(data, html: true).parse
          return Document.new(data) if data.xml_declaration

          Document.new(data).nodes.first
        end

        def is_xml_comment?(node)
          node = node.unwrap if node.respond_to? :unwrap
          node.is_a?(::Oga::XML::Comment)
        end

        def replace_nodes(root, nodes)
          text_node = ::Oga::XML::Text.new(text: nodes)
          root.unwrap.children = ::Oga::XML::NodeSet.new([text_node])
          root
        end
      end
    end
  end
end
