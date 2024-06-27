# frozen_string_literal: true

require "thor"

module Plurimath
  self.autoload :Math, "plurimath/math"

  class Cli < Thor
    desc "convert", "Convert between math formats"

    option :input,
           aliases: "-i",
           desc: "Input value should be in quoted string"

    option :input_format,
           aliases: "-f",
           default: "asciimath",
           desc: "Input format should be in quoted string => \"asciimath\""

    option :file_path,
           aliases: "-p",
           desc: "Reads input from a file instead of the command line input. Use this for larger inputs or when input contains special characters.",
           force: :boolean

    option :output_format,
           aliases: "-t",
           default: "mathml",
           desc: "Convert to language type, Output format should be in quoted string"

    option :math_rendering,
           aliases: "-m",
           force: :boolean,
           default: 'false',
           desc: "Render converted equation as math zone display tree, Boolean only"

    option :display_style,
           aliases: "-d",
           desc: "DisplayStyle is only supported for OMML and MathML conversion, Boolean only",
           force: :boolean

    option :split_on_linebreak,
           aliases: "-s",
           desc: "Splits only MathML and OMML equations into multiple equations, Boolean only",
           force: :boolean

    def convert
      input          = options[:input]
      input_string   = options[:file_path] ? File.read(options[:file_path]) : input
      warn_and_exit("missing generator argument --input or --file-input") unless input_string

      input_format   = options[:input_format]
      output_format  = options[:output_format]
      formula        = Plurimath::Math.parse(input_string, input_format)
      return puts formula.to_display(output_format.to_sym) if YAML.safe_load(options[:math_rendering])

      display_style  = options[:display_style]
      split          = options[:split_on_linebreak]
      style          = display_style.to_s.empty? ? "true" : display_style
      output_text = case output_format
                    when "unicodemath"
                      formula.to_unicodemath
                    when "asciimath"
                      formula.to_asciimath
                    when "mathml"
                      formula.to_mathml(display_style: style, split_on_linebreak: split)
                    when "latex"
                      formula.to_latex
                    when "omml"
                      formula.to_omml(display_style: style, split_on_linebreak: split)
                    else
                      warn_and_exit("Invalid output format: #{output_format}")
                    end

      puts output_text
    end

    no_commands do
      def warn_and_exit(message)
        warn(message)
        exit 1
      end
    end
  end
end
