# frozen_string_literal: true

require "plurimath/xml_engine"
require "corelib/array/pack" if RUBY_ENGINE == "opal"
require "oga"

module Plurimath
  module XMLEngine
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
          if data.xml_declaration
            Document.new(data)
          else
            Document.new(data).nodes.first
          end
        end

        def is_xml_comment?(node)
          node = node.unwrap if node.respond_to? :unwrap
          node.is_a?(Comment)
        end

        def replace_nodes(root, nodes)
          root.unwrap.children = ::Oga::XML::NodeSet.new([::Oga::XML::Text.new(text: nodes)])
          root
        end
      end

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

      class Node < Wrapper
        # Ox removes text nodes that are whitespace-only.
        # There exists a weird edge case on which Plurimath depends:
        # <mi> <!-- xxx --> &#x3C0;<!--GREEK SMALL LETTER PI--> </mi>
        # If the last text node of an element that does not contain other
        # elements is a whitespace, it preserves it. The first one can be
        # safely removed.
        def nodes
          children = @wrapped.children
          length = children.length
          preserve_last = true
          children.map.with_index do |i,idx|
            if preserve_last && idx == length-1 && i.is_a?(::Oga::XML::Text)
              i.text
            elsif i.is_a? ::Oga::XML::Text
              remove_indentation(i)
            elsif i.is_a? ::Oga::XML::Comment
              Node.new(i)
            else
              preserve_last = false
              Node.new(i)
            end
          end.compact
        end

        def [](attr)
          attr = attr.to_s

          @wrapped.attributes.each do |e|
            return e.value if [e.name, e.name.split(":").last].include? attr
          end

          nil
        end

        def []=(attr, value)
          # Here we tap into the internal representation due to some likely
          # bug in Oga
          attr = ::Oga::XML::Attribute.new(name: attr.to_s)
          attr.element = @wrapped
          attr.instance_variable_set(:@value, value.to_s)
          attr.instance_variable_set(:@decoded, true)
          @wrapped.attributes << attr
        end

        def <<(other)
          other = other.unwrap if other.respond_to? :unwrap

          case other
          when String
            text = other
            # Here we tap into the internal representation due to some likely
            # bug in Oga
            other = ::Oga::XML::Text.new
            other.instance_variable_set(:@from_plurimath, true)
            other.instance_variable_set(:@text, text)
            other.instance_variable_set(:@decoded, true)
          end

          @wrapped.children << other.dup
          self
        end

        def attributes
          @wrapped.attributes.to_h do |e|
            [e.name.split(":").last, e.value]
          end
        end

        def locate(xpath)
          @wrapped.xpath(xpath).map do |i|
            case i
            when ::Oga::XML::Text
              i.text
            when ::Oga::XML::Attribute
              i.value
            else
              Node.new(i)
            end
          end
        end

        def name
          @wrapped.name
        end

        def name=(new_name)
          @wrapped.name = new_name
        end

        private

        def remove_indentation(text)
          from_us = text.instance_variable_get(:@from_plurimath)
          !from_us && text.text.strip == "" ? nil : text.text
        end
      end

      class Document < Node
      end

      Comment = ::Oga::XML::Comment

      # Dump the tree just as if we were Ox. This is a limited implementation.
      class Dumper
        def initialize(tree, indent: nil)
          @tree = tree
          @indent = indent
          @depth = 0
          @out = ""
        end

        def dump(node = @tree)
          case node
          when Node
            nodes = node.nodes
            if nodes.length == 0
              line_break
              @out += "<#{node.unwrap.name}#{dump_attrs(node)}/>"
            else
              line_break
              @out += "<#{node.unwrap.name}#{dump_attrs(node)}>"
              @depth += 1
              nodes.each { |i| dump(i) }
              @depth -= 1
              line_break unless nodes.last.is_a?(::String)
              @out += "</#{node.unwrap.name}>"
            end
          when ::String
            @out += entities(node)
          end

          line_break if node.object_id == @tree.object_id

          self
        end

        attr_reader :out

        ORD_AMP="&".ord
        ORD_LT="<".ord
        ORD_GT=">".ord
        ORD_APOS="'".ord
        ORD_QUOT='"'.ord
        ORD_NEWLINE="\n".ord
        ORD_CARRIAGERETURN="\r".ord

        def self.entities(text,attr=false)
          text.to_s.chars.map(&:ord).map do |i|
            if i == ORD_AMP
              "&amp;"
            elsif i == ORD_LT
              "&lt;"
            elsif i == ORD_GT
              "&gt;"
            elsif i == ORD_QUOT && attr
              "&quot;"
            elsif i == ORD_NEWLINE || i == ORD_CARRIAGERETURN
              i.chr("utf-8")
            elsif i < 0x20
              "&#x#{i.to_s(16).rjust(4, "0")};"
            else
              i.chr("utf-8")
            end
          end.join
        end

        private

        def dump_attrs(node)
          node.unwrap.attributes.map do |i|
            # Currently, this is not part of the contract. But in the future
            # it may be needed to also handle namespaces:
            #
            # if i.namespace
            #   %{ #{i.namespace.name}:#{i.name}="#{attr_entities i.value}"}
            %{ #{i.name}="#{attr_entities i.value}"}
          end.join
        end

        def entities(text)
          self.class.entities(text)
        end

        def attr_entities(text)
          self.class.entities(text, true)
        end

        def line_break
          @out += "\n"
          @out += " " * (@indent * @depth) if @indent
        end
      end
    end
  end
end
