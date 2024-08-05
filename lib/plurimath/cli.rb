# frozen_string_literal: true

require "thor"
require "tmpdir"

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
      warn_and_exit("missing generator argument --input or --file-input") unless input_string

      output_format  = options[:output_format]
      input_format   = options[:input_format]
      formula        = Plurimath::Math.parse(input_string, input_format)
      split          = options[:split_on_linebreak]
      return puts formula.to_display(output_format.to_sym) if YAML.safe_load(options[:math_rendering])

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

    desc "render", "Generate png, svg or pdf file of the input"

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

    option :output,
           aliases: "-o",
           required: true,
           desc: "Expected file name with extension for output. Extension must be png, svg or pdf only."

    option :display_style,
           aliases: "-d",
           desc: "DisplayStyle is only supported for MathML conversion, Boolean only",
           force: :boolean

    def render
      warn_and_exit("missing generator argument --input or --file-input") unless input_string

      output = options[:output]
      warn_and_exit("wrong generator argument output value") unless %w[.png .svg .pdf].include?(File.extname(output))

      unless `which lasem-render-0.6` && $?.success?
        warn_and_exit("Lasem doesn't exist, see github repo https://github.com/LasemProject/lasem for use and installation documentation.")
      end

      Dir.mktmpdir do |dir|
        input_file_path = File.join(dir, "mathml.mml")
        formula = Plurimath::Math.parse(input_string, options[:input_format])
        File.open(input_file_path, "w+") do |file|
          file.write(formula.to_mathml(display_style: style))
        end
        `lasem-render-0.6 "#{input_file_path}" -o #{output}`
      end
    end

    no_commands do
      def warn_and_exit(message)
        warn(message)
        exit 1
      end

      def style
        display_style = options[:display_style]
        display_style.to_s.empty? ? "true" : display_style
      end

      def input_string
        input = options[:input]
        options[:file_path] ? File.read(options[:file_path]) : input
      end

      def create_file(mathml)
        File.open("mathml.mml", "w+") do |file|
          file.puts(mathml)
        end
      end
    end
  end
end
