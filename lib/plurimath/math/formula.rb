# frozen_string_literal: true

module Plurimath
  module Math
    class Formula
      attr_accessor :value

      def initialize(value = [])
        @value = value.is_a?(Array) ? value : [value]
      end

      def ==(object)
        object.value == value
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
        Utility.update_nodes(
          Utility.ox_element("mrow"),
          mathml_content,
        )
      end

      def mathml_content
        value.map(&:to_mathml_without_math_tag)
      end

      def to_latex
        value.map(&:to_latex).join(" ")
      end

      def to_html
        value.map(&:to_html).join(" ")
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
        para_element << math_element
        Ox.dump(para_element, indent: 2).gsub("&amp;", "&")
      end

      def omml_content
        value.map do |object|
          if object.is_a?(Symbol)
            mt = Utility.ox_element("t", namespace: "m")
            mt << object.value
          else
            object.to_omml_without_math_tag
          end
        end
      end

      def to_omml_without_math_tag
        if value.length == 2 && ["underover", "powerbase"].include?(
          value&.first&.class_name,
        )
          nary_tag
        else
          r_element = Utility.ox_element("r", namespace: "m")
          r_element << Utility.rpr_element if ["symbol", "number", "text"].include?(value&.first&.class_name)
          Utility.update_nodes(r_element, omml_content)
        end
      end

      def nary_tag
        nary_tag = Utility.ox_element("nary", namespace: "m")
        e_tag    = Utility.ox_element("e", namespace: "m")
        e_tag   << value&.last&.to_omml_without_math_tag
        Utility.update_nodes(
          nary_tag,
          [
            value.first.omml_nary_tag,
            e_tag,
          ].flatten.compact,
        )
      end

      def class_name
        self.class.name.split("::").last.downcase
      end
    end
  end
end
