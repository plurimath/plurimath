module Plurimath
  module XMLEngine
    class Ox
      class Element
        attr_accessor :attributes

        def initialize(node)
          @node = node.is_a?(String) ? ::Ox::Element.new(node) : node
        end

        def ==(object)
          self.class == object.class &&
            match_nodes(init_nodes_vars(xml_nodes), object.xml_nodes)
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
          xml_nodes.attributes.delete(attribute)
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
          xml_nodes.nodes.map { |node| self.class.new(node) }
        end

        def each(&block)
          xml_nodes.each(&block)
        end

        def map(&block)
          xml_nodes.map(&block)
        end

        def dumper
          ::Ox.dump(xml_nodes)
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

        private

        def update_nodes(element, all_nodes)
          all_nodes&.each do |node|
            next update_nodes(element, node) if node.is_a?(Array)

            element << node unless node.nil?
          end
          element
        end

        def update_attrs(element, attributes = @attributes)
          attributes&.each { |key, value| element.attributes[key] = value }
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

        def match_nodes(self_nodes, object_nodes)
          # TODO: Work in progress
        end
      end
    end
  end
end
