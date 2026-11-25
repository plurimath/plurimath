# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Msgroup < UnaryFunction
        autoload :DisplayTreeMethods, "plurimath/math/function/msgroup/display_tree_methods"

        # --- Catalog documentation (see Plurimath::Documentation) ---
        DESCRIPTION = "Groups elementary-math rows so their positions shift together."
        REFERENCE = "https://www.w3.org/TR/mathml4/#presm_msgroup"
        EXAMPLE = -> { new([sym("x")]) }
        CATALOG_FORMAT_LIMITATIONS = {
          asciimath: {
            status: :limited,
            notes: ["Elementary-math grouping is omitted; only the group contents are emitted."],
          },
          latexmath: {
            status: :limited,
            notes: ["Elementary-math grouping is omitted; only the group contents are emitted."],
          },
          omml: {
            status: :limited,
            notes: ["Elementary-math grouping is omitted; only the group contents are emitted."],
          },
        }.freeze
        # --- end catalog documentation ---

        node_fields :parameter_one, collections: %i[parameter_one],
                                    scalars: { hide_function_name: :boolean }

        def to_asciimath(options:)
          parameter_one.map do |param|
            param.to_asciimath(options: options)
          end.join
        end

        def to_latex(options:)
          parameter_one.map { |param| param.to_latex(options: options) }.join
        end

        def to_mathml_without_math_tag(intent, options:)
          XmlHelper.update_nodes(
            XmlHelper.ox_element("msgroup"),
            parameter_one.map do |object|
              object&.to_mathml_without_math_tag(intent, options: options)
            end,
          )
        end

        def to_omml_without_math_tag(display_style, options:)
          omml_value(display_style, options: options)
        end

        def to_html
          "<i>#{parameter_one.map(&:to_html).join}</i>"
        end

        def to_asciimath_math_zone(spacing, last = false, _indent = true,
options:)
          Msgroup.include(DisplayTreeMethods) unless Msgroup < DisplayTreeMethods
          super
        end

        def to_latex_math_zone(spacing, last = false, indent = true, options:)
          Msgroup.include(DisplayTreeMethods) unless Msgroup < DisplayTreeMethods
          super
        end

        def to_mathml_math_zone(spacing, last = false, indent = true, options:)
          Msgroup.include(DisplayTreeMethods) unless Msgroup < DisplayTreeMethods
          super
        end

        def to_omml_math_zone(spacing, last = false, indent = true,
display_style:, options:)
          Msgroup.include(DisplayTreeMethods) unless Msgroup < DisplayTreeMethods
          super
        end

        def to_unicodemath_math_zone(spacing, last = false, indent = true,
options:)
          Msgroup.include(DisplayTreeMethods) unless Msgroup < DisplayTreeMethods
          super
        end

        def to_unicodemath(options:)
          parameter_one.map do |param|
            param.to_unicodemath(options: options)
          end.join
        end

        def line_breaking(obj)
          custom_array_line_breaking(obj)
        end
      end
    end
  end
end
