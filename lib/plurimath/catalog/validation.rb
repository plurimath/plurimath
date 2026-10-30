# frozen_string_literal: true

module Plurimath
  module Catalog
    # Validates the public data contract independently of class discovery.
    module Validation
      FORMATS = %w[asciimath latexmath mathml omml].freeze
      ARITIES = %w[unary binary ternary].freeze
      STATUSES = %w[available limited unavailable].freeze
      COMMON_KEYS = %w[name type kind arity formats].freeze

      module_function

      def validate_all!(entries)
        unless entries.is_a?(Array)
          raise InvalidEntryError, "Catalog entries must be an Array"
        end

        seen = {}
        entries.each do |entry|
          validate!(entry)
          identity = entry.values_at("kind", "name")
          if seen[identity]
            raise InvalidEntryError, "Duplicate catalog identity: #{identity.join('/')}"
          end

          seen[identity] = true
        end
        entries
      end

      def validate!(entry)
        validate_metadata!(entry)
        expected = COMMON_KEYS + FORMATS
        expected += %w[description reference] if entry["kind"] == "function"
        unless entry.keys.all?(String) && entry.keys.sort == expected.sort
          raise InvalidEntryError, "#{entry['name']}: unexpected or missing entry fields"
        end

        formats = entry["formats"]
        unless formats.is_a?(Hash) && formats.keys.all?(String) &&
            formats.keys.sort == FORMATS.sort
          raise InvalidEntryError, "#{entry['name']}: formats must contain all four formats"
        end

        FORMATS.each { |format| validate_format!(entry, format) }
        entry
      end

      def validate_metadata!(entry)
        unless entry.is_a?(Hash) && entry["name"].is_a?(String) &&
            entry["name"].match?(/\A[a-z0-9][a-z0-9_-]*\z/)
          raise InvalidEntryError, "Catalog name must be a nonempty, safe lowercase slug"
        end

        case entry["kind"]
        when "function" then validate_function!(entry)
        when "symbol"
          unless entry["type"] == "symbol" && entry["arity"].nil?
            raise InvalidEntryError, "#{entry['name']}: symbol type must be symbol and arity nil"
          end
        else
          raise InvalidEntryError, "#{entry['name']}: kind must be function or symbol"
        end
        entry
      end

      def validate_notes!(notes, format, required:)
        unless notes.is_a?(Array) && notes.all? { |note| present_string?(note) } &&
            (!required || !notes.empty?)
          raise InvalidEntryError, "#{format}: notes must be nonempty strings#{' with a reason' if required}"
        end
      end

      def validate_function!(entry)
        unless ARITIES.include?(entry["arity"]) && entry["type"] == entry["arity"]
          raise InvalidEntryError, "#{entry['name']}: function type and reference arity must agree"
        end
        unless present_string?(entry["description"]) &&
            entry["reference"].is_a?(String) && entry["reference"].match?(%r{\Ahttps?://[^\s/?#]+(?:[/?#]\S*)?\z})
          raise InvalidEntryError, "#{entry['name']}: function requires a description and HTTP(S) reference"
        end
      end

      def validate_format!(entry, format)
        output = entry[format]
        record = entry["formats"][format]
        unless output.is_a?(String) && record.is_a?(Hash) &&
            record.keys.all?(String) &&
            record.keys.sort == %w[notes status] && STATUSES.include?(record["status"])
          raise InvalidEntryError, "#{entry['name']}/#{format}: invalid output or format metadata"
        end

        unavailable = record["status"] == "unavailable"
        if output.strip.empty? && !unavailable
          raise InvalidEntryError, "#{entry['name']}/#{format}: empty output must be unavailable"
        end

        validate_notes!(record["notes"], format, required: record["status"] != "available")
      end

      def present_string?(value)
        value.is_a?(String) && !value.strip.empty?
      end

      private_class_method :validate_function!, :validate_format!, :present_string?
    end
  end
end
