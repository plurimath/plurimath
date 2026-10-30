# frozen_string_literal: true

module Plurimath
  class Cli < Thor
    # Standalone command object for `plurimath render`. Usable on its own:
    #   Plurimath::Cli::Render.new(options).call
    class Render
      include Helpers

      def call
        text = input_string
        warn_and_exit("missing generator argument --input or --file-input") unless text

        output_path = options[:output]
        configure_xml_engine(options[:input_format], "mathml")
        bytes = Plurimath::Math.render(
          text, options[:input_format],
          format: render_format(output_path), **render_options
        )
        write_render_output(bytes, output_path)
      rescue Plurimath::Error => e
        warn_and_exit(e.message)
      end

      private

      def write_render_output(bytes, output_path)
        return File.binwrite(output_path, bytes) if output_path

        $stdout.binmode
        $stdout.write(bytes)
      end

      # Resolve the output image format. The --output extension is authoritative
      # for a file (so `-o x.png` always writes PNG); --format applies when there
      # is no usable extension (stdout, or an extensionless --output); otherwise
      # svg. Math::Renderer validates the result and raises
      # Errors::UnsupportedRenderFormat on an unsupported value.
      def render_format(output_path)
        extension = File.extname(output_path.to_s).delete_prefix(".")
        return extension.downcase.to_sym unless extension.empty?

        explicit = options[:format]
        return explicit.to_s.downcase.to_sym if explicit && !explicit.to_s.strip.empty?

        :svg
      end

      # Keyword options forwarded to Plurimath::Math.render. --display-style is
      # passed only when given, so the formula's own display style is honored by
      # default; nil-valued numeric options are dropped.
      def render_options
        opts = {}
        opts[:display_style] = options[:display_style] unless options[:display_style].nil?
        opts[:split_on_linebreak] = options[:split_on_linebreak] unless options[:split_on_linebreak].nil?
        Plurimath::Math::Renderer::LASEM_OPTIONS.each do |key|
          value = options[key]
          opts[key] = value unless value.nil?
        end
        opts
      end
    end
  end
end
