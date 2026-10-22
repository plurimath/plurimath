# frozen_string_literal: true

module Plurimath
  class Asciimath
    class Parser
      # Which parser builds the tree for Transform. "parslet" is the in-tree
      # Asciimath::Parse; "amath" is the extracted amath gem, adapted back to a
      # Parslet tree by SliceAdapter.
      # TODO(amath): make amath the only engine, then delete parse.rb and its
      # autoload (keep Constants: omml/utility.rb and math/function/table.rb
      # use it).
      ENGINE_ENV = "PLURIMATH_ASCIIMATH_ENGINE"
      ENGINES = %w[parslet amath].freeze
      DEFAULT_ENGINE = "parslet"

      attr_accessor :text

      def self.engine
        engine = ENV.fetch(ENGINE_ENV, DEFAULT_ENGINE)
        return engine if ENGINES.include?(engine)

        raise ArgumentError,
              "#{ENGINE_ENV} must be one of #{ENGINES.join(', ')}, " \
              "got #{engine.inspect}"
      end

      def initialize(text)
        @text = text
          &.gsub(/(\|:|:\|)/, "|")
          &.gsub(/(\{:)/, "ℒ")
          &.gsub(/(:\})/, "ℛ")
          &.gsub(/(\(:)/, "ᑕ")
          &.gsub(/(:\))/, "ᑐ")
      end

      def parse
        nodes = parse_tree
        transformed_tree = Transform.new.apply(nodes)
        return transformed_tree if transformed_tree.is_a?(Math::Formula)

        Math::Formula.new(transformed_tree)
      end

      private

      def parse_tree
        case self.class.engine
        when "amath" then amath_tree
        else Parse.new.parse(text)
        end
      end

      def amath_tree
        require "amath" unless defined?(::Amath)

        tree = ::Amath.parse(text, decimal: Plurimath.configuration.decimal)
        SliceAdapter.convert(tree, text)
      end
    end
  end
end
