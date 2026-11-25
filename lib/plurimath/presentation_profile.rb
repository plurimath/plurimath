# frozen_string_literal: true

module Plurimath
  # Proposed identifier semantics for #134. Selected per render; no global state.
  class PresentationProfile
    autoload :Projection, "plurimath/presentation_profile/projection"
    autoload :Layout, "plurimath/presentation_profile/layout"
    autoload :Tokens, "plurimath/presentation_profile/tokens"

    ALIASES = { "pi" => "π", "Pi" => "Π" }.freeze
    ROLES = %i[constant variable context_free_function].freeze
    private_constant :ALIASES, :ROLES

    def self.resolve(profile)
      return profile if profile.is_a?(self)
      return new if profile == :iso_80000_2

      raise ArgumentError, "Unknown presentation profile: #{profile.inspect}"
    end

    attr_reader :layout

    def initialize(constants: %w[pi π e], context_free_functions: %w[Pi Π F G H],
                   fallback_italics: {}, fraction_layout: nil, sum_limits: nil,
                   integral_limits: nil, symbols: {}, operator_spacing: {})
      @constants = constants.map { |name| normalize_name(name).dup.freeze }.uniq.freeze
      @functions = context_free_functions.map { |name| normalize_name(name).dup.freeze }.uniq.freeze
      @fallback_italics = normalize_fallback(fallback_italics)
      @layout = Layout.new(fraction_layout, sum_limits, integral_limits)
      @tokens = Tokens.new(symbols, operator_spacing)
      freeze
    end

    def apply(formula, context: {})
      Projection.new(self, normalize_context(context)).call(formula)
    end

    def role(name, context, function_call: false)
      name = normalize_name(name)
      return context.fetch(name) if context.key?(name)
      return :constant if @constants.include?(name)
      return :context_free_function if function_call && @functions.include?(name)
    end

    def fallback_variant(name)
      # MathML's multi-character identifier rule precedes single-letter classes.
      return "normal" if name.length > 1 && name.match?(/\A\p{L}+\z/)

      category = case name
                 when /\A[A-Z]\z/ then :upperroman
                 when /\A[a-z]\z/ then :lowerroman
                 when /\A[\p{Greek}&&\p{Lu}]\z/ then :uppergreek
                 when /\A[\p{Greek}&&\p{Ll}]\z/ then :lowergreek
                 end
      return unless @fallback_italics.key?(category)

      @fallback_italics[category] ? "italic" : "normal"
    end

    def render_tokens(root, format)
      @tokens.apply(root, format)
    end

    # This belongs in the caller's Word settings part, never inside an equation.
    def to_omml_math_properties
      layout.to_omml_math_properties
    end

    private

    def normalize_fallback(settings)
      keys = %i[upperroman lowerroman uppergreek lowergreek]
      unless settings.is_a?(Hash) && (settings.keys - keys).empty? &&
          settings.values.all? { |value| value == true || value == false }
        raise ArgumentError, "fallback_italics requires character classes and boolean values"
      end

      settings.dup.freeze
    end


    def normalize_name(name)
      name = name.to_s
      ALIASES.fetch(name, name)
    end

    def normalize_context(context)
      raise ArgumentError, "context must be a Hash of identifier roles" unless context.is_a?(Hash)

      context.each_with_object({}) do |(name, role), roles|
        unless ROLES.include?(role)
          raise ArgumentError, "Unknown identifier role: #{role.inspect}"
        end

        name = normalize_name(name)
        if roles.key?(name) && roles[name] != role
          raise ArgumentError, "Conflicting roles for identifier: #{name.inspect}"
        end
        roles[name] = role
      end
    end
  end
end
