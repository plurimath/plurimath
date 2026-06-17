# frozen_string_literal: true

require "thor"
require_relative "../plurimath"
require_relative "cli/helpers"
require_relative "cli/convert"
require_relative "cli/render"

module Plurimath
  # Thor entry point. Declares each command's options and delegates to an
  # independent, standalone command object (Cli::Convert / Cli::Render) that can
  # also be used directly: `Plurimath::Cli::Render.new(options).call`.
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
           default: "false",
           desc: "Render converted equation as math zone display tree, Boolean only"

    option :display_style,
           aliases: "-d",
           desc: "DisplayStyle is only supported for OMML and MathML conversion, Boolean only",
           force: :boolean

    option :split_on_linebreak,
           aliases: "-s",
           desc: "Splits only MathML and OMML equations into multiple equations, Boolean only",
           force: :boolean

    option :xml_engine,
           aliases: "-e",
           default: "ox",
           desc: "XML engine to use for parsing and rendering (ox or oga)"

    def convert
      Convert.new(options).call
    end

    desc "render", "Render math to an image (svg/png/pdf/ps) via the optional lasem gem"

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
           desc: "Output file path; the image format is taken from its extension (.svg/.png/.pdf/.ps). When omitted, the rendered bytes are written to stdout."

    option :format,
           aliases: "-r",
           desc: "Image format (svg, png, pdf, ps). Used for stdout or when --output has no usable extension; a file's extension takes precedence. Defaults to svg."

    option :display_style,
           aliases: "-d",
           desc: "DisplayStyle, Boolean only. Defaults to the parsed formula's display style.",
           force: :boolean

    option :split_on_linebreak,
           aliases: "-s",
           desc: "Splits into multiple equations. Note: lasem renders a single MathML document.",
           force: :boolean

    option :ppi, type: :numeric, desc: "Pixels per inch for raster output (lasem)"
    option :zoom, type: :numeric, desc: "Render scale factor (lasem)"
    option :width, type: :numeric, desc: "Explicit output width (lasem)"
    option :height, type: :numeric, desc: "Explicit output height (lasem)"
    option :offset_x, type: :numeric, desc: "Horizontal offset (lasem)"
    option :offset_y, type: :numeric, desc: "Vertical offset (lasem)"

    option :xml_engine,
           aliases: "-e",
           default: "ox",
           desc: "XML engine to use for parsing and rendering (ox or oga)"

    def render
      Render.new(options).call
    end
  end
end
