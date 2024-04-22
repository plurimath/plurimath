module Plurimath
  module XmlEngine
    class Oga
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
            attr_key = i.namespace_name ? "#{i.namespace_name}:#{i.name}" : i.name
            %{ #{attr_key}="#{attr_entities(i.value)}"}
          end.join
        end

        def entities(text, attr = false)
          self.class.entities(to_unicode(text, attr))
        end

        def attr_entities(text)
          self.class.entities(text, true)
        end

        def line_break
          @out += "\n"
          @out += " " * (@indent * @depth) if @indent
        end

        def to_unicode(text, attr = false)
          attr ? Utility.html_entity_to_unicode(text) : text
        end
      end
    end
  end
end
