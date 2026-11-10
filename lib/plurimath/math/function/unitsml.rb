# frozen_string_literal: true

Plurimath.load_mml
require "unitsml"

module Plurimath
  module Math
    module Function
      class Unitsml < Core
        # The parsed form is derived from the text, so only the text and the
        # input string are mapped.
        node_fields scalars: { text: :string, input_string: :string }

        def initialize(text = nil)
          @text = text
          @unitsml = ::Unitsml.parse(text) if text
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

        # The unicodemath_unit option makes a multi-letter unit symbol read
        # back as one upright run (see FontStyle::Normal#to_unicodemath).
        def to_unicodemath(options:)
          formula(options).to_unicodemath(
            options: options.merge(unicodemath_unit: true),
          )
        end

        def to_html(options:)
          formula(options).to_html(options: options)
        end

        def to_mathml_without_math_tag(intent, options:)
          mathml = formula(options).to_mathml_without_math_tag(intent,
                                                               options: options)
          mathml["unitsml"] = true
          if options&.dig(:unitsml,
                          :xml)
            wrapped_unitsml_xml(mathml, unitsml,
                                options)
          else
            mathml
          end
        end

        def to_omml_without_math_tag(display_style, options:)
          formula(options).to_omml_without_math_tag(display_style,
                                                    options: options)
        end

        def to_asciimath_math_zone(spacing = "", last = false, indent = true,
options:)
          formula(options).to_asciimath_math_zone(spacing, last, indent,
                                                  options: options)
        end

        def to_latex_math_zone(spacing = "", last = false, indent = true,
options:)
          formula(options).to_latex_math_zone(spacing, last, indent,
                                              options: options)
        end

        def to_mathml_math_zone(spacing = "", last = false, indent = true,
options:)
          formula(options).to_mathml_math_zone(spacing, last, indent,
                                               options: options)
        end

        def to_omml_math_zone(spacing = "", last = false, indent = true,
options:)
          formula(options).to_omml_math_zone(spacing, last, indent,
                                             options: options)
        end

        def to_unicodemath_math_zone(spacing = "", last = false, indent = true,
options:)
          formula(options).to_unicodemath_math_zone(spacing, last, indent,
                                                    options: options)
        end

        private

        def formula(options)
          unitsml.to_plurimath(options.fetch(:unitsml, {}))
        end

        # A node built by from_hash has only its text, so parse it on first use.
        def unitsml
          @unitsml ||= ::Unitsml.parse(text)
        end

        def wrapped_unitsml_xml(mathml, unitsml, options)
          xml = Plurimath.xml_engine.load("<mrow>#{unitsml.to_xml(options.fetch(
                                                                    :unitsml, {}
                                                                  ))}</mrow>")
          xref = xml.nodes.find { |node| node.respond_to?(:[]) }&.[](:id)
          mathml[:xref] = xref if xref
          XmlHelper.update_nodes(mathml, xml.nodes)
        end
      end
    end
  end
end
