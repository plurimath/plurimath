# frozen_string_literal: true

module Plurimath
  module Math
    class Formula < Core
      attr_accessor :value, :left_right_wrapper, :displaystyle, :input_string

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
        input_string: nil
      )
        @value = value.is_a?(Array) ? value : [value]
        left_right_wrapper = false if @value.first.is_a?(Function::Left)
        @left_right_wrapper = left_right_wrapper
        @displaystyle = boolean_display_style(display_style)
      end

      def ==(object)
        object.value == value &&
          object.left_right_wrapper == left_right_wrapper
      end

      def to_asciimath
        value.map(&:to_asciimath).join(" ")
      rescue
        parse_error!(:asciimath)
      end

      def to_mathml(display_style: displaystyle)
        math_attrs = {
          xmlns: "http://www.w3.org/1998/Math/MathML",
          display: "block",
        }
        style_attrs = { displaystyle: boolean_display_style(display_style) }
        math  = Utility.ox_element("math", attributes: math_attrs)
        style = Utility.ox_element("mstyle", attributes: style_attrs)
        Utility.update_nodes(style, mathml_content)
        Utility.update_nodes(math, [style])
        Ox.dump(math, indent: 2).gsub("&amp;", "&")
      rescue
        parse_error!(:mathml)
      end

      def to_mathml_without_math_tag
        return mathml_content unless left_right_wrapper

        Utility.update_nodes(
          Utility.ox_element("mrow"),
          mathml_content,
        )
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

      def to_omml(display_style: displaystyle)
        new_line_support.map do |object|
          para_element = Utility.ox_element("oMathPara", attributes: omml_attrs, namespace: "m")
          para_element << Utility.update_nodes(
            Utility.ox_element("oMath", namespace: "m"),
            object.omml_content(boolean_display_style(display_style)),
          )
          Ox.dump(para_element, indent: 2).gsub("&amp;", "&").gsub(/^\n/, "")
        end.join
      rescue
        parse_error!(:omml)
      end

      def omml_content(display_style)
        value&.map { |val| val.insert_t_tag(display_style) }
      end

      def to_omml_without_math_tag(display_style)
        omml_content(display_style)
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
        filtered_values(value).map.with_index(1) do |object, index|
          last = index == @values.length
          object.to_asciimath_math_zone(new_space(spacing, indent), last, indent)
        end
      end

      def to_latex_math_zone(spacing = "", last = false, indent = true)
        filtered_values(value).map.with_index(1) do |object, index|
          last = index == @values.length
          object.to_latex_math_zone(new_space(spacing, indent), last, indent)
        end
      end

      def to_mathml_math_zone(spacing = "", last = false, indent = true)
        filtered_values(value).map.with_index(1) do |object, index|
          last = index == @values.length
          object.to_mathml_math_zone(new_space(spacing, indent), last, indent)
        end
      end

      def to_omml_math_zone(spacing = "", last = false, indent = true, display_style:)
        filtered_values(value).map.with_index(1) do |object, index|
          last = index == @values.length
          object.to_omml_math_zone(new_space(spacing, indent), last, indent, display_style: display_style)
        end
      end

      def extract_class_from_text
        return false unless value.length < 2 && value.first.is_a?(Function::Text)

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
        self.class.new(value.map(&:cloned_objects))
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
          return
        end

        value.each.with_index do |object, index|
          object.line_breaking(obj)
          break obj.insert(value.slice!(index+1..value.size)) if obj.value_exist?
        end
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

      def insert(values)
        update(Array(value) + values)
      end

      def parse_error!(type)
        Math.parse_error!(input_string, type)
      end
    end
  end
end
