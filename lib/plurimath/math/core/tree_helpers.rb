# frozen_string_literal: true

module Plurimath
  module Math
    class Core
      # Shared helpers used only by the display-tree writers.
      module TreeHelpers
        def ascii_fields_to_print(field, options = {})
          return if field.nil?

          hashed = common_math_zone_conversion(field, options)
          options[:array] << "#{hashed[:spacing]}|_ \"#{field&.to_asciimath(options: options[:options])}\"#{hashed[:field_name]}\n"
          return unless ModelHelper.validate_math_zone(field, lang: :asciimath)

          options[:array] << field&.to_asciimath_math_zone(
            hashed[:function_spacing], hashed[:last], hashed[:indent], options: options[:options]
          )
        end

        def latex_fields_to_print(field, options = {})
          return if field.nil?

          hashed = common_math_zone_conversion(field, options)
          options[:array] << "#{hashed[:spacing]}|_ \"#{field&.to_latex(options: options[:options])}\"#{hashed[:field_name]}\n"
          return unless ModelHelper.validate_math_zone(field, lang: :latex)

          options[:array] << field&.to_latex_math_zone(hashed[:function_spacing],
                                                       hashed[:last], hashed[:indent], options: options[:options])
        end

        def mathml_fields_to_print(field, options = {})
          return if field.nil?

          hashed = common_math_zone_conversion(field, options)
          options[:array] << "#{hashed[:spacing]}|_ \"#{dump_mathml(field,
                                                                    options: options[:options])}\"#{hashed[:field_name]}\n"
          return unless ModelHelper.validate_math_zone(field, lang: :mathml,
                                                              intent: options[:intent], options: options[:options])

          options[:array] << field&.to_mathml_math_zone(
            hashed[:function_spacing], hashed[:last], hashed[:indent], options: options[:options]
          )
        end

        def omml_fields_to_print(field, options = {})
          return if field.nil?

          hashed = common_math_zone_conversion(field, options)
          display_style = options[:display_style]
          options[:array] << "#{hashed[:spacing]}|_ \"#{dump_omml(field,
                                                                  display_style, options: options[:options])}\"#{hashed[:field_name]}\n"
          return unless ModelHelper.validate_math_zone(field, lang: :omml)

          options[:array] << field&.to_omml_math_zone(hashed[:function_spacing],
                                                      hashed[:last], hashed[:indent], display_style: display_style, options: options[:options])
        end

        def unicodemath_fields_to_print(field, options = {})
          return if field.nil?

          hashed = common_math_zone_conversion(field, options)
          options[:array] << "#{hashed[:spacing]}|_ \"#{field&.to_unicodemath(options: options[:options])}\"#{hashed[:field_name]}\n"
          return unless ModelHelper.validate_math_zone(field, lang: :unicodemath)

          options[:array] << field&.to_unicodemath_math_zone(
            hashed[:function_spacing], hashed[:last], hashed[:indent], options: options[:options]
          )
        end

        def common_math_zone_conversion(field, options = {})
          {
            spacing: options[:spacing],
            last: options[:last] || true,
            indent: !field.is_a?(Formula),
            function_spacing: "#{options[:spacing]}#{options[:additional_space]}",
            field_name: (options[:field_name] ? " #{options[:field_name]}" : ""),
          }
        end

        def filtered_values(value, lang:, options: {})
          @values = ModelHelper.filter_math_zone_values(value, lang: lang,
                                                               options: options)
        end

        def gsub_spacing(spacing, last)
          spacing.gsub("|_", last ? "  " : "| ")
        end

        def pretty_print_instance_variables
          excluded_vars = %i[
            @left_right_wrapper
            @using_default
            @displaystyle
            @__encoding
            @__register
            @__ordered
            @unitsml
            @__mixed
            @is_mrow
            @values
          ]
          instance_variables.sort - excluded_vars
        end

        def to_ms_value
          new_arr = []
          case self
          when Math::Symbols::Symbol
            new_arr << (value ? value.to_s : to_unicodemath(options: {}))
          when Math::Number, Math::Function::Text
            new_arr << value
          else
            parameters_to_ms_value(new_arr)
            if respond_to?(:value) && value.is_a?(Array)
              new_arr << value&.map(&:to_ms_value)&.join(" ")
            end
          end
          new_arr
        end

        private

        def parameters_to_ms_value(array)
          ALL_PARAMETERS.each do |field|
            array << get("@#{field}")&.to_ms_value if respond_to?(field)
          end
        end

      end
    end
  end
end
