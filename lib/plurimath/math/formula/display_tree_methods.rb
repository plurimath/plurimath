# frozen_string_literal: true

module Plurimath
  module Math
    class Formula
      # Display-tree writers load only when their public entrypoints are used.
      module DisplayTreeMethods
        def to_display(type = nil, formatter: nil, unitsml: {},
          unary_function_spacing: true, tree: :display)
          unless %i[display semantic].include?(tree)
            raise ArgumentError, "Unknown display tree: #{tree.inspect}"
          end
          if tree == :display && type.downcase.to_sym == :formula
            return ClassTree.new.render(self)
          end

          options = {
            formatter: formatter,
            unitsml: unitsml,
            unary_function_spacing: unary_function_spacing,
          }
          options[:formula] ||= self
          if tree == :semantic
            return SemanticTree.new(type.downcase.to_sym, options).render(self)
          end
          return type_error!(type) unless MATH_ZONE_TYPES.include?(type.downcase.to_sym)

          math_zone = case type
                      when :asciimath
                        "  |_ \"#{to_asciimath(options: options)}\"\n#{to_asciimath_math_zone(
                          '     ', options: options
                        ).join}"
                      when :latex
                        "  |_ \"#{to_latex(options: options)}\"\n#{to_latex_math_zone(
                          '     ', options: options
                        ).join}"
                      when :mathml
                        mathml = to_mathml(formatter: formatter, unary_function_spacing: options[:unary_function_spacing]).gsub(
                          /\n\s*/, ""
                        )
                        math_display = to_mathml_math_zone("     ",
                                                           options: options).join
                        "  |_ \"#{mathml}\"\n#{math_display}"
                      when :omml
                        omml = to_omml.gsub(/\n\s*/, "")
                        omml_display = to_omml_math_zone("     ",
                                                         display_style: displaystyle, options: options).join
                        "  |_ \"#{omml}\"\n#{omml_display}"
                      when :unicodemath
                        "  |_ \"#{to_unicodemath(options: options)}\"\n#{to_unicodemath_math_zone(
                          '     ', options: options
                        ).join}"
                      end
          <<~MATHZONE.sub(/\n$/, "")
            |_ Math zone
            #{math_zone}
          MATHZONE
        end

        def to_asciimath_math_zone(spacing = "", last = false, indent = true,
          options:)
          filtered_values(value,
                          lang: :asciimath).map.with_index(1) do |object, index|
            last = index == @values.length
            object.to_asciimath_math_zone(new_space(spacing, indent), last,
                                          indent, options: options)
          end
        end

        def to_latex_math_zone(spacing = "", last = false, indent = true,
          options:)
          filtered_values(value,
                          lang: :latex).map.with_index(1) do |object, index|
            last = index == @values.length
            object.to_latex_math_zone(new_space(spacing, indent), last, indent,
                                      options: options)
          end
        end

        def to_mathml_math_zone(spacing = "", last = false, indent = true,
          options:)
          filtered_values(value, lang: :mathml,
                                 options: options).map.with_index(1) do |object, index|
            last = index == @values.length
            object.to_mathml_math_zone(new_space(spacing, indent), last, indent,
                                       options: options)
          end
        end

        def to_omml_math_zone(spacing = "", last = false, indent = true,
          display_style:, options:)
          filtered_values(value, lang: :omml).map.with_index(1) do |object, index|
            last = index == @values.length
            object.to_omml_math_zone(new_space(spacing, indent), last, indent,
                                     display_style: display_style, options: options)
          end
        end

        def to_unicodemath_math_zone(spacing = "", last = false, indent = true,
          options:)
          filtered_values(value,
                          lang: :unicodemath).map.with_index(1) do |object, index|
            last = index == @values.length
            object.to_unicodemath_math_zone(new_space(spacing, indent), last,
                                            indent, options: options)
          end
        end

        protected

        def new_space(spacing, indent)
          if value.any? { |val| val.class_name == "left" } && value.any? do |val|
            val.class_name == "right"
          end
            return spacing
          end

          indent && wrapable?(spacing) ? "#{spacing}|_ " : spacing
        end

        def wrapable?(spacing)
          left_right_wrapper && !spacing.end_with?("|_ ")
        end
      end
    end
  end
end
