# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Color < BinaryFunction
        autoload :DisplayTreeMethods, "plurimath/math/function/color/display_tree_methods"

        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "An expression rendered in a specified color."
        REFERENCE = "https://developer.mozilla.org/en-US/docs/Web/MathML/Reference/Element/mstyle"
        EXAMPLE = -> { new(sym("red"), sym("x")) }
        CATALOG_FORMAT_LIMITATIONS = {
          omml: {
            status: :limited,
            notes: ["Supports hexadecimal colors and the basic CSS color names; other colors are refused."],
          },
        }.freeze
        # --- end catalog documentation ---

        node_fields :parameter_one, :parameter_two,
                    scalars: { hide_function_name: :boolean }, hashes: %i[options]

        FUNCTION = {
          name: "color",
          first_value: "mathcolor",
          second_value: "text",
        }.freeze

        # OMML requires an RGB value rather than a CSS color spelling.
        OMML_COLORS = {
          "black" => "000000", "silver" => "C0C0C0", "gray" => "808080",
          "white" => "FFFFFF", "maroon" => "800000", "red" => "FF0000",
          "purple" => "800080", "fuchsia" => "FF00FF", "green" => "008000",
          "lime" => "00FF00", "olive" => "808000", "yellow" => "FFFF00",
          "navy" => "000080", "blue" => "0000FF", "teal" => "008080",
          "aqua" => "00FFFF", "grey" => "808080",
        }.freeze

        def initialize(parameter_one = nil,
                       parameter_two = nil,
                       options = {})
          super(parameter_one, parameter_two)
          @options = options unless options.empty?
        end

        def to_asciimath(options:)
          first_value = "(#{parameter_one&.to_asciimath(options: options)&.gsub(
            /\s/, ''
          )})"
          second_value = "(#{parameter_two&.to_asciimath(options: options)})"
          "color#{first_value}#{second_value}"
        end

        def to_mathml_without_math_tag(intent, options:)
          XmlHelper.update_nodes(
            XmlHelper.ox_element(
              "mrow",
              attributes: mathml_options,
            ),
            [parameter_two&.to_mathml_without_math_tag(intent,
                                                       options: options)],
          )
        end

        def to_latex(options:)
          first_value = parameter_one&.to_asciimath(options: options)&.gsub(
            /\s/, ""
          )
          second_value = parameter_two&.to_latex(options: options)
          "{\\#{class_name}{#{first_value}} #{second_value}}"
        end

        def to_omml_without_math_tag(display_style, options:)
          return [] unless parameter_two

          color = omml_color
          nodes = Array(parameter_two.insert_t_tag(display_style, options: options)).flatten.compact
          nodes.each { |node| color_omml_runs(node, color) }
          nodes
        end

        def to_omml_math_zone(spacing, last = false, _, display_style:,
options:)
          Color.include(DisplayTreeMethods) unless Color < DisplayTreeMethods
          super
        end

        # The color is one value. AsciiMath reads color(red) as the
        # symbols r, e and d, which write back space-separated; drop the
        # spaces as #to_asciimath and the MathML attribute already do.
        def to_unicodemath(options:)
          color = parameter_one.to_unicodemath(options: options)&.gsub(/\s/, "")
          "#{color_symbol}(#{color}&#{parameter_two.to_unicodemath(options: options)})"
        end

        protected

        def omml_color
          value = parameter_one&.to_asciimath(options: {})&.gsub(/[\s"]/, "")
          named = OMML_COLORS[value&.downcase]
          return named if named
          return value.delete_prefix("#").upcase if value&.match?(/\A#?[0-9a-f]{6}\z/i)
          if value&.match?(/\A#[0-9a-f]{3}\z/i)
            return value.delete_prefix("#").chars.map { |char| char * 2 }.join.upcase
          end

          raise Plurimath::Error, "Unsupported OMML color: #{value.inspect}"
        end

        def color_omml_runs(node, color)
          return unless node.respond_to?(:name)
          unless node.name == "m:r"
            node.nodes.each { |child| color_omml_runs(child, color) }
            return
          end

          properties = node.nodes.find { |child| child.respond_to?(:name) && child.name == "w:rPr" }
          unless properties
            properties = ox_element("rPr", namespace: "w")
            # Math run properties precede WordprocessingML run properties.
            index = node.nodes.first&.name == "m:rPr" ? 1 : 0
            node.insert_in_nodes(index, properties)
          end
          tag = attr_key == :mathbackground ? "shd" : "color"
          return if properties.nodes.any? { |child| child.respond_to?(:name) && child.name == "w:#{tag}" }

          attributes = tag == "shd" ? { "w:val": "clear", "w:fill": color } : { "w:val": color }
          properties << ox_element(tag, namespace: "w", attributes: attributes)
        end

        def color_symbol
          options&.dig(:backgroundcolor) ? "☁" : "✎"
        end

        def attr_key
          options&.dig(:backgroundcolor) ? :mathbackground : :mathcolor
        end

        def mathml_options
          return unless parameter_one

          color_options = {}
          color_options[attr_key] =
            parameter_one.to_asciimath(options: options)&.gsub(/\s/, "")&.gsub(
              '"', ""
            )
          color_options
        end
      end
    end
  end
end
