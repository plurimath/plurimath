# frozen_string_literal: true

module Plurimath
  module Math
    class Formula
      attr_accessor :value, :left_right_wrapper

      def initialize(value = [], left_right_wrapper = true)
        @value = value.is_a?(Array) ? value : [value]
        left_right_wrapper = false if @value.first.is_a?(Function::Left)
        @left_right_wrapper = left_right_wrapper
      end

      def ==(object)
        object.value == value &&
          object.left_right_wrapper == left_right_wrapper
      end

      def to_asciimath
        value.map(&:to_asciimath).join(" ")
      end

      def to_mathml
        math_attrs = {
          xmlns: "http://www.w3.org/1998/Math/MathML",
          display: "block",
        }
        style_attrs = { displaystyle: "true" }
        math  = Utility.ox_element("math", attributes: math_attrs)
        style = Utility.ox_element("mstyle", attributes: style_attrs)
        Utility.update_nodes(style, mathml_content)
        Utility.update_nodes(math, [style])
        Ox.dump(math, indent: 2).gsub("&amp;", "&")
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
      end

      def to_html
        value&.map(&:to_html)&.join(" ")
      end

      def omml_math_attrs
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

      def to_omml
        para_element = Utility.ox_element(
          "oMathPara",
          attributes: omml_math_attrs,
          namespace: "m",
        )
        math_element = Utility.ox_element("oMath", namespace: "m")
        Utility.update_nodes(math_element, omml_content)
        Utility.update_nodes(para_element, Array(math_element))
        Ox.dump(para_element, indent: 2).gsub("&amp;", "&").lstrip
      end

      def omml_content(insert_r_tag = true)
        value.map do |object|
          if ["symbol", "number", "text"].include?(object.class_name)
            if object.is_a?(Symbol)
              mt = Utility.ox_element("t", namespace: "m")
              mt << object.value
              [mt]
            else
              mt = object.to_omml_without_math_tag
            end
            next mt unless insert_r_tag

            r_element = (Utility.ox_element("r", namespace: "m") << Utility.rpr_element)
            Utility.update_nodes(r_element, Array(mt))
          else
            object.to_omml_without_math_tag
          end
        end
      end

      def to_omml_without_math_tag
        return nary_tag if nary_tag_able?

        if value&.all? { |obj| ["symbol", "number", "text"].include?(obj.class_name) }
          r_element = Utility.ox_element("r", namespace: "m")
          r_element << Utility.rpr_element
          Utility.update_nodes(r_element, omml_content(false))
          [r_element]
        else
          omml_content
        end
      end

      def nary_tag
        nary_tag = Utility.ox_element("nary", namespace: "m")
        e_tag    = Utility.ox_element("e", namespace: "m")
        Utility.update_nodes(e_tag, insert_t_tag(value&.last))
        Utility.update_nodes(
          nary_tag,
          (value.first.omml_nary_tag << e_tag),
        )
        [nary_tag]
      end

      def class_name
        self.class.name.split("::").last.downcase
      end

      def extract_class_from_text
        return false unless value&.length < 2 && value&.first&.is_a?(Function::Text)

        value.first.parameter_one
      end

      def nary_attr_value
        value.first.nary_attr_value
      end

      def nary_tag_able?
        value.length == 2 &&
        ["underover", "powerbase"].include?(value&.first&.class_name) &&
        (
          value&.first&.parameter_one&.to_omml_without_math_tag.length == 1 ||
          value&.first&.parameter_one&.to_omml_without_math_tag.match?(/^&#x\w*\d*;$/)
        )
      end

      def insert_t_tag(parameter)
        parameter_value = parameter&.to_omml_without_math_tag
        r_tag = Utility.ox_element("r", namespace: "m")
        if parameter.is_a?(Symbol)
          r_tag << (Utility.ox_element("t", namespace: "m") << parameter_value)
          [r_tag]
        elsif parameter.is_a?(Number)
          Utility.update_nodes(r_tag, parameter_value)
          [r_tag]
        else
          Array(parameter_value)
        end
      end
    end
  end
end
