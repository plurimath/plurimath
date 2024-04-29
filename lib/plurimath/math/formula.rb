# frozen_string_literal: true

module Plurimath
  module Math
    class Formula < Core
      attr_accessor :value, :left_right_wrapper, :displaystyle, :input_string, :unitsml

      MATH_ZONE_TYPES = %i[
        omml
        latex
        mathml
        asciimath
      ].freeze

      def initialize(
        value = [],
        left_right_wrapper = true,
        display_style: true,
        input_string: nil,
        unitsml: false
      )
        @value = value.is_a?(Array) ? value : [value]
        left_right_wrapper = false if @value.first.is_a?(Function::Left)
        @left_right_wrapper = left_right_wrapper
        @displaystyle = boolean_display_style(display_style)
        @unitsml = unitsml if unitsml
      end

      def ==(object)
        object.respond_to?(:value) &&
          object.respond_to?(:left_right_wrapper) &&
          object.value == value &&
          object.left_right_wrapper == left_right_wrapper
      end

      def to_asciimath
        value.map(&:to_asciimath).join(" ")
      rescue
        parse_error!(:asciimath)
      end

      def to_mathml(display_style: displaystyle, split_on_linebreak: false)
        return line_breaked_mathml(display_style) if split_on_linebreak

        math_attrs = {
          xmlns: "http://www.w3.org/1998/Math/MathML",
          display: "block",
        }
        style_attrs = { displaystyle: boolean_display_style(display_style) }
        math  = ox_element("math", attributes: math_attrs)
        style = ox_element("mstyle", attributes: style_attrs)
        Utility.update_nodes(style, mathml_content)
        Utility.update_nodes(math, [style])
        unitsml_post_processing(math.nodes, math)
        dump_nodes(math, indent: 2)
      rescue
        parse_error!(:mathml)
      end

      def line_breaked_mathml(display_style)
        new_line_support.map do |formula|
          formula.to_mathml(display_style: display_style)
        end.join
      end

      def to_mathml_without_math_tag
        return mathml_content unless left_right_wrapper

        mrow = ox_element("mrow")
        mrow[:unitsml] = true if unitsml
        Utility.update_nodes(mrow, mathml_content)
      end

      def mathml_content
        value.map(&:to_mathml_without_math_tag)
      end

      def to_latex
        value&.map(&:to_latex)&.join(" ")
      rescue
        parse_error!(:latex)
      end

      def to_html
        value&.map(&:to_html)&.join(" ")
      rescue
        parse_error!(:html)
      end

      def omml_attrs
        {
          "xmlns:m": "http://schemas.openxmlformats.org/officeDocument/2006/math",
          "xmlns:mc": "http://schemas.openxmlformats.org/markup-compatibility/2006",
          "xmlns:mo": "http://schemas.microsoft.com/office/mac/office/2008/main",
          "xmlns:mv": "urn:schemas-microsoft-com:mac:vml",
          "xmlns:o": "urn:schemas-microsoft-com:office:office",
          "xmlns:r": "http://schemas.openxmlformats.org/officeDocument/2006/relationships",
          "xmlns:v": "urn:schemas-microsoft-com:vml",
          "xmlns:w": "http://schemas.openxmlformats.org/wordprocessingml/2006/main",
          "xmlns:w10": "urn:schemas-microsoft-com:office:word",
          "xmlns:w14": "http://schemas.microsoft.com/office/word/2010/wordml",
          "xmlns:w15": "http://schemas.microsoft.com/office/word/2012/wordml",
          "xmlns:wne": "http://schemas.microsoft.com/office/word/2006/wordml",
          "xmlns:wp": "http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing",
          "xmlns:wp14": "http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing",
          "xmlns:wpc": "http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas",
          "xmlns:wpg": "http://schemas.microsoft.com/office/word/2010/wordprocessingGroup",
          "xmlns:wpi": "http://schemas.microsoft.com/office/word/2010/wordprocessingInk",
          "xmlns:wps": "http://schemas.microsoft.com/office/word/2010/wordprocessingShape",
        }
      end

      def to_omml(display_style: displaystyle, split_on_linebreak: false)
        objects = split_on_linebreak ? new_line_support : [self]

        para_element = Utility.ox_element("oMathPara", attributes: omml_attrs, namespace: "m")
        objects.each.with_index(1) do |object, index|
          para_element << Utility.update_nodes(
            Utility.ox_element("oMath", namespace: "m"),
            object.omml_content(boolean_display_style(display_style)),
          )
          next if objects.length == index

          para_element << omml_br_tag
        end
        dump_nodes(para_element, indent: 2)
      rescue
        parse_error!(:omml)
      end

      def omml_content(display_style)
        value&.map { |val| val.insert_t_tag(display_style) }
      end

      def to_omml_without_math_tag(display_style)
        omml_content(display_style)
      end

      def to_unicodemath
        Utility.html_entity_to_unicode(unicodemath_value).gsub(/\s\/\s/, "/")
      rescue
        parse_error!(:unicodemath)
      end

      def to_display(type = nil)
        return type_error! unless MATH_ZONE_TYPES.include?(type.downcase.to_sym)

        math_zone = case type
                    when :asciimath
                      "  |_ \"#{to_asciimath}\"\n#{to_asciimath_math_zone("     ").join}"
                    when :latex
                      "  |_ \"#{to_latex}\"\n#{to_latex_math_zone("     ").join}"
                    when :mathml
                      "  |_ \"#{to_mathml.gsub(/\n\s*/, "")}\"\n#{to_mathml_math_zone("     ").join}"
                    when :omml
                      "  |_ \"#{to_omml.gsub(/\n\s*/, "")}\"\n#{to_omml_math_zone("     ", display_style: displaystyle).join}"
                    end
        <<~MATHZONE.sub(/\n$/, "")
        |_ Math zone
        #{math_zone}
        MATHZONE
      end

      def to_asciimath_math_zone(spacing = "", last = false, indent = true)
        filtered_values(value, lang: :asciimath).map.with_index(1) do |object, index|
          last = index == @values.length
          object.to_asciimath_math_zone(new_space(spacing, indent), last, indent)
        end
      end

      def to_latex_math_zone(spacing = "", last = false, indent = true)
        filtered_values(value, lang: :latex).map.with_index(1) do |object, index|
          last = index == @values.length
          object.to_latex_math_zone(new_space(spacing, indent), last, indent)
        end
      end

      def to_mathml_math_zone(spacing = "", last = false, indent = true)
        filtered_values(value, lang: :mathml).map.with_index(1) do |object, index|
          last = index == @values.length
          object.to_mathml_math_zone(new_space(spacing, indent), last, indent)
        end
      end

      def to_omml_math_zone(spacing = "", last = false, indent = true, display_style:)
        filtered_values(value, lang: :omml).map.with_index(1) do |object, index|
          last = index == @values.length
          object.to_omml_math_zone(new_space(spacing, indent), last, indent, display_style: display_style)
        end
      end

      def extract_class_name_from_text
        return unless value.length < 2 && value.first.is_a?(Function::Text)

        value.first.parameter_one
      end

      def nary_attr_value
        value.first.nary_attr_value
      end

      def validate_function_formula
        (value.none?(Function::Left) || value.none?(Function::Right))
      end

      def value_exist?
        value && !value.empty?
      end

      def update(object)
        self.value = Array(object)
      end

      def cloned_objects
        cloned_obj = value.map(&:cloned_objects)
        formula = self.class.new(cloned_obj)
        formula.left_right_wrapper = @left_right_wrapper
        formula
      end

      def new_line_support(array = [])
        cloned = cloned_objects
        obj = self.class.new
        cloned.line_breaking(obj)
        array << cloned
        obj.value_exist? ? obj.new_line_support(array) : array
      end

      def line_breaking(obj)
        if result.size > 1
          breaked_result = result.first.last.omml_line_break(result)
          update(Array(breaked_result.shift))
          obj.update(breaked_result.flatten)
          reprocess_value(obj)
          return
        end

        value.each.with_index(1) do |object, index|
          object.line_breaking(obj)
          break obj.insert(value.slice!(index..value.size)) if obj.value_exist?
        end
      end

      def reprocess_value(obj)
        new_obj = self.class.new([])
        self.line_breaking(new_obj)
        if new_obj.value_exist?
          obj.value.insert(0, Function::Linebreak.new)
          obj.value.insert(0, self.class.new(new_obj.value))
        end
      end

      def insert(values)
        update(Array(value) + values)
      end


      def mini_sized?
        true if value&.first&.mini_sized?
      end

      protected

      def boolean_display_style(display_style = displaystyle)
        YAML.safe_load(display_style.to_s)
      end

      def new_space(spacing, indent)
        if value.any? { |val| val.class_name == "left" } && value.any? { |val| val.class_name == "right" }
          return spacing
        end

        (indent && wrapable?(spacing)) ? spacing + "|_ " : spacing
      end

      def wrapable?(spacing)
        left_right_wrapper && !spacing.end_with?("|_ ")
      end

      def parse_error!(type)
        Math.parse_error!(input_string, type)
      end

      def omml_br_tag
        r_tag = ox_element("r", namespace: "m")
        r_tag << ox_element("br")
      end

      def unitsml_post_processing(nodes, prev_node)
        nodes.each.with_index do |node, index|
          if node[:unitsml]
            pre_index = index - 1
            pre_node = nodes[pre_index] if pre_index.zero? || pre_index.positive?
            prev_node.insert_in_nodes(index, space_element(node)) if valid_previous?(pre_node)
            node.remove_attr("unitsml")
          end
          unitsml_post_processing(node.nodes, node) if node.nodes.none?(String)
        end
      end

      def space_element(node)
        element = (ox_element("mo") << "&#x2062;")
        element[:rspace] = "thickmathspace" if text_in_tag?(node.xml_nodes.nodes)
        element
      end

      def text_in_tag?(nodes)
        next_nodes = nodes.first.nodes
        if next_nodes.all?(String)
          Utility.html_entity_to_unicode(next_nodes.first).match?(/\p{L}|\p{N}/)
        else
          text_in_tag?(next_nodes)
        end
      end

      def negated_value?
        value.last.is_a?(Math::Symbols::Symbol) && value.last.value == "&#x338;"
      end

      def unicodemath_value
        (negated_value? || mini_sized?) ? value&.map(&:to_unicodemath)&.join : value&.map(&:to_unicodemath)&.join(" ")
      end

      def valid_previous?(previous)
        return unless previous

        ["mi", "mn"].include?(previous.name) ||
          inside_tag?(previous)
      end

      def inside_tag?(previous)
        previous&.nodes&.any? do |node|
          next if node.is_a?(String)

          valid_previous?(node) if node.xml_node?
        end
      end
    end
  end
end
