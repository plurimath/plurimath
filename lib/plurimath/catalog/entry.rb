# frozen_string_literal: true

module Plurimath
  module Catalog
    # Builds YAML-ready entries without changing the legacy rendering fields.
    module Entry
      RENDERERS = {
        "asciimath" => :to_asciimath,
        "latexmath" => :to_latex,
        "mathml" => :to_mathml,
        "omml" => :to_omml,
      }.freeze
      EMPTY_OUTPUT_NOTE = "The serializer returned no output."
      METADATA_FIELDS = %i[name type kind arity description reference].freeze

      module_function

      def build(formula:, limitations: {}, **attributes)
        entry = metadata(attributes)
        Validation.validate_metadata!(entry)
        declarations = normalize_limitations(limitations)
        unless RENDERERS.values.all? { |method| formula.respond_to?(method) }
          raise InvalidEntryError, "#{entry['name']}: example must support all four serializers"
        end

        formats = {}
        RENDERERS.each do |format, method|
          entry[format] = formula.public_send(method)
          formats[format] = format_metadata(entry[format], declarations[format])
        end
        entry["formats"] = formats
        Validation.validate!(entry)
        entry
      end

      def metadata(attributes)
        unless (attributes.keys - METADATA_FIELDS).empty?
          raise InvalidEntryError, "Unknown catalog metadata fields"
        end

        entry = {
          "name" => attributes[:name], "type" => label(attributes[:type]),
          "kind" => label(attributes[:kind]), "arity" => label(attributes[:arity])
        }
        if entry["kind"] == "function"
          entry["description"] = attributes[:description]
          entry["reference"] = attributes[:reference]
        end
        entry
      end

      def normalize_limitations(limitations)
        unless limitations.is_a?(Hash)
          raise InvalidEntryError, "CATALOG_FORMAT_LIMITATIONS must be a Hash"
        end

        limitations.each_with_object({}) do |(format, declaration), result|
          key = label(format)
          unless RENDERERS.key?(key) && !result.key?(key)
            raise InvalidEntryError, "Unknown or duplicate limitation format: #{format.inspect}"
          end

          result[key] = normalize_declaration(declaration, key)
        end
      end

      def normalize_declaration(declaration, format)
        unless declaration.is_a?(Hash)
          raise InvalidEntryError, "#{format} limitation must be a Hash"
        end

        normalized = declaration.transform_keys { |key| label(key) }
        unless normalized.keys.all?(String) && normalized.keys.sort == %w[notes status] &&
            normalized.size == declaration.size
          raise InvalidEntryError, "#{format} limitation requires only status and notes"
        end

        status = label(normalized["status"])
        unless %w[limited unavailable].include?(status)
          raise InvalidEntryError, "#{format} limitation status must be limited or unavailable"
        end

        Validation.validate_notes!(normalized["notes"], format, required: true)
        { "status" => status, "notes" => normalized["notes"].map(&:dup) }
      end

      def format_metadata(output, declaration)
        result = declaration || { "status" => "available", "notes" => [] }
        if output.is_a?(String) && output.strip.empty?
          result = {
            "status" => "unavailable",
            "notes" => (result["notes"] + [EMPTY_OUTPUT_NOTE]).uniq,
          }
        end
        result
      end

      def label(value)
        return if value.nil?
        return value.to_s if value.is_a?(String) || value.is_a?(Symbol)

        raise InvalidEntryError, "Catalog labels must be strings or symbols"
      end

      private_class_method :metadata, :normalize_limitations,
                           :normalize_declaration, :format_metadata, :label
    end
  end
end
