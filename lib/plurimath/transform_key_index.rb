# frozen_string_literal: true

module Plurimath
  # Parsanol::Transform tries every rule, in order, on every node of the
  # tree. Most rules in Plurimath's rule tables are Hash patterns, which
  # match only a Hash with exactly their keys. Including this module in a
  # Parsanol::Transform subclass, before its rules are defined, makes it
  # list once, for each key list met, the rules that could match it, in the
  # table's order, and try only those. A pattern that is not a Hash (or one
  # the class did not see defined, such as a parent's rule) is tried on
  # every node, as before. The first rule that matches is the same as with
  # the full scan.
  module TransformKeyIndex
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def rule(expression, &transformer)
        rules = super
        pattern_keys[rules.first.first] = expression.keys.freeze if expression.is_a?(Hash)
        rules
      end

      def pattern_keys
        @pattern_keys ||= {}.compare_by_identity
      end

      # The class rules that can match a node with the keys +keys+
      # (nil for a node that is not a Hash), in precedence order.
      def candidate_rules(keys)
        rules = class_rules
        index = @candidate_rules
        index = @candidate_rules = {} if index.nil? || @indexed_rules_size != rules.size
        @indexed_rules_size = rules.size
        index[keys] ||= rules.select do |pattern, _|
          expected = pattern_keys[pattern]
          expected.nil? || (!keys.nil? && expected.size == keys.size && expected.all? { |key| keys.include?(key) })
        end.freeze
      end
    end

    private

    # Parsanol::Transform#attempt_transformation over the candidate rules
    # only. Instance rules keep the full scan.
    def attempt_transformation(node, ctx)
      return super unless @instance_rules.empty?

      self.class.candidate_rules(node.is_a?(Hash) ? node.keys : nil).each do |pattern, block|
        bindings = pattern.match(node, ctx)
        return call_on_match(bindings, block) if bindings
      end
      handle_unmatched(node)
    end
  end
end
