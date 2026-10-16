# frozen_string_literal: true

module Plurimath
  module XmlEngine
    class LeptrisEngine
      class Element
        # strip_prefix mirrors ox's strip_namespace: names of a document
        # loaded via LeptrisEngine.load report local names, while elements
        # constructed by name keep their prefix ("w:rPr").
        def initialize(node, strip_prefix: false)
          @strip_prefix = strip_prefix
          @node =
            if node.is_a?(String)
              # leptris parses namespace prefixes leniently, so prefixed names
              # (w:rPr et al.) need no declaration; keep the owning document
              # reachable so the FFI handle outlives this wrapper.
              fragment = ::Leptris::XML.parse("<#{node}/>")
              @document = fragment
              fragment.root
            else
              @document = node.document if node.respond_to?(:document)
              node
            end
          # The parser reports local names (prefix stripped) while the tree
          # keeps the prefix in serialization; restore the constructed
          # spelling so #name matches the ox contract ("w:rPr", not "rPr").
          @node.name = node if node.is_a?(String) && @node.name != node
        end

        def ==(object)
          self.class == object.class &&
            @node.to_xml == object.xml_nodes.to_xml
        end

        def [](object)
          # leptris's own #[] lookup is namespace-aware and misses prefixed
          # names; the attributes hash keeps the constructed spelling, which
          # matches ox's flat string keys.
          @node.attributes[object.to_s]&.value
        end

        def []=(attr, value)
          @node[attr.to_s] = Utility.html_entity_to_unicode(value.to_s)
        end

        def name
          local = @node.name
          return local if @strip_prefix || local.include?(":")

          # attached nodes report only the local name; re-attach the prefix
          # the tree still carries for the constructed-name contract
          prefix = @node.prefix
          prefix ? "#{prefix}:#{local}" : local
        end

        def name=(new_name)
          @node.name = new_name
        end

        def set_attr(attrs)
          attrs&.each { |key, value| self[key] = value }
          self
        end

        def remove_attr(attribute)
          @node.remove_attribute(attribute.to_s)
        end

        def <<(object)
          @node.add_child(
            object.is_a?(String) ? text_node_for(object) : attachable(object.xml_nodes),
          )
          self
        end

        def attributes
          @node.attributes.transform_values(&:value)
        end

        def attributes=(attr_hash = {})
          set_attr(attr_hash)
        end

        def xml_nodes
          @node
        end

        def nodes
          @node.children.map { |node| element_or_string(node) }
        end

        def each(&block)
          nodes.each(&block)
        end

        def map(&block)
          nodes.map(&block)
        end

        def xml_node?
          true
        end

        def insert_in_nodes(index, element)
          children = @node.children
          node = attachable(element.xml_nodes)
          if index >= children.size
            @node.add_child(node)
          else
            children[index].add_previous_sibling(node)
          end
          self
        end

        # Ox-style locate paths ("*/mfrac/@intent") are XPath-compatible once
        # made relative; attribute results come back as plain strings, as
        # Ox's locate returns them.
        def locate(string)
          @node.xpath("./#{string}").map do |found|
            case found
            when ::Leptris::XML::Attr then found.value
            when ::Leptris::XML::Text then found.text
            else self.class.new(found, strip_prefix: @strip_prefix)
            end
          end
        end

        def replace_nodes(nodes_array)
          @node.children.each(&:unlink)
          nodes_array.each do |node|
            @node.add_child(
              if node.is_a?(Element)
                attachable(node.xml_nodes)
              elsif node.is_a?(String)
                text_node_for(node)
              else
                attachable(node)
              end,
            )
          end
          self
        end

        def is_xml_comment?
          @node.is_a?(::Leptris::XML::Comment)
        end

        private

        # Engine insertion has value semantics: ox and oga let the same
        # element object be inserted twice and render twice (Abs relies on
        # this for its open/close fences). leptris nodes are handles into a
        # C tree where a second add_child MOVES the node, so an
        # already-attached node is deep-copied first; freshly built nodes
        # (no parent yet) attach directly.
        def attachable(node)
          return node unless node.parent

          if node.is_a?(::Leptris::XML::Element)
            node.dup
          else
            # dup is only supported for element nodes; rebuild text by value
            text_node_for(node.text)
          end
        end

        # Ox stores string children raw (no markup decoding); leptris treats
        # add_child(String) as markup, so go through create_text_node to keep
        # entity text like "&#x3b2;" literal.
        def text_node_for(string)
          doc = @node.respond_to?(:document) ? @node.document : @node
          doc.create_text_node(string)
        end

        def element_or_string(node)
          node.is_a?(::Leptris::XML::Text) ? node.text : self.class.new(node, strip_prefix: @strip_prefix)
        end
      end
    end
  end
end
