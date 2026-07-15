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
        display_style = options[:display_style]
        split         = options[:split_on_linebreak]
        style         = display_style.to_s.empty? ? "true" : display_style
        case output_format
        when "unicodemath" then formula.to_unicodemath
        when "asciimath"   then formula.to_asciimath
        when "mathml"      then formula.to_mathml(display_style: style, split_on_linebreak: split)
        when "latex"       then formula.to_latex
        when "omml"        then formula.to_omml(display_style: style, split_on_linebreak: split)
        else warn_and_exit("Invalid output format: #{output_format}")
        end
      end
    end
  end
end
