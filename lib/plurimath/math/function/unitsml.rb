# frozen_string_literal: true

require "unitsml"

module Plurimath
  module Math
    module Function
      class Unitsml < Core
        attr_accessor :text

        def initialize(text)
          @text = text
          @unitsml = ::Unitsml.parse(text)
        end

        def cloned_objects
          self.class.new(text)
        end

        def ==(other)
          other.is_a?(Unitsml) &&
            other.text == @text
        end

        def to_asciimath(options:)
          formula(options).to_asciimath(options: options)
        end

        def to_latex(options:)
          formula(options).to_latex(options: options)
        end

        def to_unicodemath(options:)
          formula(options).to_unicodemath(options: options)
        end

        def to_html(options:)
          formula(options).to_html(options: options)
        end

        def to_mathml_without_math_tag(intent, options:)
          mathml = formula(options).to_mathml_without_math_tag(intent, options: options)
          mathml["unitsml"] = true
          options&.dig(:unitsml, :xml) ? wrapped_unitsml_xml(mathml, @unitsml, options) : mathml
        end

        def to_omml_without_math_tag(display_style, options:)
          formula(options).to_omml_without_math_tag(display_style, options: options)
        end

        def to_asciimath_math_zone(spacing = "", last = false, indent = true, options:)
          formula(options).to_asciimath_math_zone(spacing, last, indent, options: options)
        end

        def to_latex_math_zone(spacing = "", last = false, indent = true, options:)
          formula(options).to_latex_math_zone(spacing, last, indent, options: options)
        end

        def to_mathml_math_zone(spacing = "", last = false, indent = true, options:)
          formula(options).to_mathml_math_zone(spacing, last, indent, options: options)
        end

        def to_omml_math_zone(spacing = "", last = false, indent = true, options:)
          formula(options).to_omml_math_zone(spacing, last, indent, options: options)
        end

        def to_unicodemath_math_zone(spacing = "", last = false, indent = true, options:)
          formula(options).to_unicodemath_math_zone(spacing, last, indent, options: options)
        end

        private

        def formula(options)
          @unitsml.to_plurimath(options.fetch(:unitsml, {}))
        end

        def wrapped_unitsml_xml(mathml, unitsml, options)
          xml = Plurimath.xml_engine.load("<mrow>#{unitsml.to_xml(options.fetch(:unitsml, {}))}</mrow>")
          mathml.attributes[:xref] = xml.locate("*/@id").first if xml.locate("*/@id").any?
          Utility.update_nodes(mathml, xml.nodes)
        end
      end
    end
  end
end
