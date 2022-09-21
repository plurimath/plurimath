# frozen_string_literal: true

module Plurimath
  class Omml
    class Parse
      attr_accessor :value

      def initialize(text)
        @value = Ox.parse(text)
      end

      def parse(elements = value)
        return if elements.nil?

        element_value = nil
        elements.each do |element|
          new_elements = if element.is_a?(Ox::Element) && element.nodes
                           if element.name == "m:r"
                             if element&.nodes&.last&.name&.include?("sub")
                               Math::Function::Base.new(
                                 parse(element.nodes[1]),
                                 parse(element.nodes[2]),
                               )
                             else
                               parse_nodes(element)
                             end
                           elsif tag_name(element) == "limLoc"
                             element_value || Math::Symbol.new("∫")
                           elsif tag_name(element) == "chr"
                             Math::Symbol.new(
                               CGI.unescape(
                                 element.attributes[:"m:val"],
                               ),
                             )
                           else
                             parse_nodes(element)
                           end
                         else
                           parse_nodes(element)
                         end
          element_value = new_elements unless new_elements.nil?
        end
        element_value
      end

      def parse_nodes(element = nil)
        tag_name = tag_name(element)
        if Constants::TAGS.include?(tag_name)
          parse(element.nodes)
        elsif Constants::SUB_SUP_TAG.include?(tag_name)
          first_value  = parse(element.nodes[1])
          second_value = parse(element.nodes[2])
          if tag_name == "nary"
            parse_nary_tag(element)
          elsif ["ssubsup", "spre"].include?(tag_name.downcase)
            tag_class(tag_name).new(
              first_value,
              second_value,
              parse(element.nodes[3]),
            )
          elsif tag_name.casecmp("rad").zero?
            if first_value
              Math::Function::Root.new(first_value, second_value)
            else
              Math::Function::Sqrt.new(second_value)
            end
          else
            tag_class(tag_name).new(first_value, second_value)
          end
        else
          Math::Number.new(element)
        end
      end

      def parse_nary_tag(element)
        fonts_value  = parse(element.nodes[0])
        first_value  = parse(element.nodes[1])
        second_value = parse(element.nodes[2])
        third_value  = parse(element.nodes[3])
        if first_value.nil? && second_value.nil?
          Plurimath::Math::Formula.new(
            [
              fonts_value,
              Plurimath::Math::Formula.new(
                [
                  third_value,
                ],
              ),
            ],
          )
        else
          limloc = element.nodes[0].locate("m:limLoc")
          nary_class = if limloc && limloc.first["m:val"] == "subSup"
                         Math::Function::PowerBase
                       else
                         Math::Function::Underover
                       end
          Math::Formula.new(
            [
              nary_class.new(
                fonts_value,
                first_value,
                second_value,
              ),
              Math::Formula.new(
                [
                  third_value,
                ],
              ),
            ],
          )
        end
      end

      def tag_class(tag_name)
        if tag_name == "f"
          Math::Function::Frac
        elsif ["sSup", "sup"].include?(tag_name)
          Math::Function::Power
        elsif ["sSubSup", "sPre"].include?(tag_name)
          Math::Function::PowerBase
        end
      end

      def tag_name(node)
        if node.is_a?(String)
          node
        else
          node&.value&.gsub(/[a-zA-Z]{1,}:/, "")
        end
      end
    end
  end
end
