require "plurimath/xml_engine/oga/wrapper"

module Plurimath
  module XmlEngine
    class Oga
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
          attr.instance_variable_set(:@value, encode_entities(value.to_s))
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

        def each
          nodes.each
        end

        def set_attr(attr_hash)
          Array(attr_hash)&.each { |key, value| @wrapped.set(key.to_s, encode_entities((value.to_s))) }
        end

        def xml_node?
          true
        end

        def xml_nodes
          self
        end

        def insert_in_nodes(index, element)
          @wrapped.children.insert(index, element.unwrap)
        end

        def remove_attr(attr_key)
          @wrapped.unset(attr_key)
        end

        private

        def remove_indentation(text)
          from_us = text.instance_variable_get(:@from_plurimath)
          !from_us && text.text.strip == "" ? nil : text.text
        end

        def encode_entities(entity)
          Utility.html_entity_to_unicode(entity)
        end
      end
    end
  end
end
