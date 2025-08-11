module Plurimath
  module XmlEngine
    class OxEngine
      class Element
        attr_accessor :attributes

        def initialize(node)
          @node = node.is_a?(String) ? ::Ox::Element.new(node) : node
        end

        def ==(object)
          self.class == object.class &&
            @node == object.xml_nodes &&
            nodes == object.nodes
        end

        def [](object)
          xml_nodes&.attributes&.dig(object.to_s)
        end

        def []=(attr, value)
          update_attrs(@node, { attr.to_s => value.to_s })
          update_attrs(self, { attr.to_s => value.to_s })
        end

        def name
          @node.name
        end

        def name=(new_name)
          @node.name = new_name
        end

        def set_attr(attrs)
          update_attrs(@node, attrs)
          update_attrs(self, attrs)
        end

        def remove_attr(attribute)
          xml_nodes&.attributes&.delete(attribute)
        end

        def <<(object)
          @node << (object.is_a?(String) ? object : object.xml_nodes)
          self
        end

        def attributes
          @node.attributes
        end

        def attributes=(attr_hash = {})
          update_attrs(@node.node, attr_hash)
          update_attrs(self, @node.attributes)
        end

        def xml_nodes
          @node
        end

        def nodes
          xml_nodes.nodes.map { |node| element_or_string(node) }
        end

        def each(&block)
          xml_nodes.each(&block)
        end

        def map(&block)
          xml_nodes.map(&block)
        end

        def xml_node?
          true
        end

        def insert_in_nodes(index, element)
          @node.nodes.insert(index, element.xml_nodes)
        end

        def locate(string)
          @node.locate(string)
        end

        def replace_nodes(nodes_array)
          xml_nodes.nodes.replace(
            nodes_array.all?(Element) ? nodes_array.map(&:xml_nodes) : nodes_array
          )
        end

        def is_xml_comment?
          xml_nodes.is_a?(::Ox::Comment)
        end

        private

        def update_nodes(element, all_nodes)
          all_nodes&.each do |node|
            next update_nodes(element, node) if node.is_a?(Array)

            element << node unless node.nil?
          end
          element
        end

        def update_attrs(element, attributes = @attributes)
          attributes&.each do |key, value|
            element.attributes[key.to_s] = Utility.html_entity_to_unicode(value.to_s)
          end
          element
        end

        def init_nodes_vars(xml_nodes)
          xml_nodes.each do |node|
            if node.is_a?(::Ox::Element)
              init_nodes_vars(node.nodes)
              node.attributes
              node.nodes
            end
          end
        end

        def element_or_string(node)
          node.is_a?(String) ? node : self.class.new(node)
        end
      end
    end
  end
end
