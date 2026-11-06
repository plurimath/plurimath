# frozen_string_literal: true

module Plurimath
  class Cli < Thor
    # Standalone command object for `plurimath convert`. Usable on its own:
    #   Plurimath::Cli::Convert.new(options).call
    class Convert
      include Helpers

      def call
        text = input_string
        warn_and_exit("missing generator argument --input or --file-input") unless text

        input_format  = options[:input_format]
        output_format = options[:output_format]
        configure_xml_engine(input_format, output_format)
        formula = Plurimath::Math.parse(text, input_format)
        return puts formula.to_display(output_format.to_sym) if options[:math_rendering].to_s == "true"

        puts convert_formula(formula, output_format)
      end

      private

      def convert_formula(formula, output_format)
        format = output_format.to_sym
        writable = Plurimath::Math::VALID_TYPES.keys - Plurimath::Math::INPUT_ONLY_TYPES
        unless writable.include?(format)
          supported = writable.sort.join(", ")
          warn_and_exit("Invalid output format: #{output_format} (supported: #{supported})")
        end

        write_output(formula, format)
      end

      # Output formats are enumerated from Plurimath::Math::VALID_TYPES (the
      # single source of truth); most formats dispatch to their `to_<type>`
      # writer, with the formats needing dedicated arguments listed explicitly.
      def write_output(formula, format)
        display_style = options[:display_style]
        split         = options[:split_on_linebreak]
        style         = display_style.to_s.empty? ? "true" : display_style
        case format
        when :unicode then formula.to_unicodemath
        when :mathml  then formula.to_mathml(display_style: style, split_on_linebreak: split)
        when :omml    then formula.to_omml(display_style: style, split_on_linebreak: split)
        # MathML with UnitsML markup embedded (the retired asciimath2unitsml
        # output shape), via Function::Unitsml's wrapped_unitsml_xml.
        when :unitsml then formula.to_mathml(unitsml: { xml: true })
        else formula.public_send("to_#{format}")
        end
      end
    end
  end
end
