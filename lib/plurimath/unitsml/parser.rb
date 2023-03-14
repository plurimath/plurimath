# frozen_string_literal: true

require_relative "parse"
require_relative "transform"
require_relative "function/unit"
require_relative "function/prefix"
require_relative "function/dimension"
module Plurimath
  class Unitsml
    class Parser
      attr_accessor :text

      def initialize(text)
        @regexp = %r{(quantity|name|symbol|multiplier):\s*}
        text = text&.match(/unitsml\((.*)\)/)
        @text = text[1] if text
      end

      def parse
        raise_error! if text.nil?

        post_extras

        nodes = Parse.new.parse(text)
        transformed_tree = Transform.new.apply(nodes)
        Math::Formula.new(transformed_tree)
      end

      def post_extras
        return "" unless @regexp.match?(text)

        @extras_hash = {}
        texts_array = text&.split(",")&.map(&:strip)
        @text = texts_array&.shift
        texts_array&.map { |text| parse_extras(text) }
      end

      def parse_extras(text)
        return nil unless @regexp.match?(text)

        key, seperator, value = text&.partition(":")
        @extras_hash[key&.to_sym] ||= value&.strip
      end

      def raise_error!
        raise Plurimath::Math::Error, Math::Error.new("Input invalid".red)
      end
    end
  end
end
