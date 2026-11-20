# frozen_string_literal: true

module Plurimath
  # Proposed identifier semantics for #134. Selected per render; no global state.
  class PresentationProfile
    autoload :Projection, "plurimath/presentation_profile/projection"

    ALIASES = { "pi" => "π", "Pi" => "Π" }.freeze
    ROLES = %i[constant variable context_free_function].freeze
    private_constant :ALIASES, :ROLES

    def self.resolve(profile)
      return profile if profile.is_a?(self)
      return new if profile == :iso_80000_2

      raise ArgumentError, "Unknown presentation profile: #{profile.inspect}"
    end

    def initialize(constants: %w[pi π e], context_free_functions: %w[Pi Π F G H])
      @constants = constants.map { |name| normalize_name(name).dup.freeze }.uniq.freeze
      @functions = context_free_functions.map { |name| normalize_name(name).dup.freeze }.uniq.freeze
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

    private

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
