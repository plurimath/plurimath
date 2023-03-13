# frozen_string_literal: true

require "parslet"
require_relative "unitsdb"
module Plurimath
  class Unitsml
    class Parse < Parslet::Parser
      include Unitsml::Unitsdb

      rule(:space)  { match(/\s/).repeat }
      rule(:power)  { str("^") >> intermediate_exp }
      rule(:units)  { @@units ||= arr_to_expression(Unitsdb.units.keys, "units") }
      rule(:prefix) { prefixes >> str("-") }

      rule(:numbers)  { match(/[0-9]/).repeat }
      rule(:integers) { str("-") >> numbers | numbers }
      rule(:extender) { (str("*") | str("/")).as(:extender) }
      rule(:prefixes) { @@prefixes ||= arr_to_expression(Unitsdb.prefixes.keys, "prefixes") }

      rule(:dimensions)  { @@dimensions ||= arr_to_expression(Unitsdb.dimensions.keys, "dimensions") }
      rule(:quantities)  { @@quantities ||= arr_to_expression(Unitsdb.quantities.keys, "quantities") }
      rule(:prefix_unit) { prefixes >> unit_and_power }

      rule(:unit_and_power)   { units >> power.maybe }
      rule(:intermediate_exp) { str("(") >> integers.as(:integer) >> str(")") | integers.as(:integer) }


      rule(:prefixes_units) do
        (str("sqrt").as(:sqrt) >> str("(") >> (prefix_unit | unit_and_power) >> str(")") >> (extender >> prefixes_units.as(:sequence)).maybe) |
          (prefix_unit >> extender >> prefixes_units.as(:sequence)) |
          (unit_and_power >> extender >> prefixes_units.as(:sequence)) |
          prefix_unit |
          unit_and_power
      end

      rule(:dimension_rules) do
        (str("sqrt").as(:sqrt) >> str("(") >> dimension_rules >> str(")") >> (extender >> dimension_rules.as(:sequence)).maybe) |
          (dimensions >> power.maybe >> extender >> dimension_rules.as(:sequence)) |
          dimensions >> power.maybe |
          dimensions
      end

      rule(:iteration) { prefixes_units | dimension_rules | prefix }

      rule(:expression) do
        # iteration >> (str(",") >> space >> str("quantity:") >> space >> quantities) |
          iteration
      end

      root :expression

      def arr_to_expression(arr, file_name)
        array = arr&.flatten&.compact&.sort_by(&:length).reverse
        array&.reduce do |expression, expr_string|
          expression = str(expression).as(file_name.to_sym) if expression.is_a?(String)
          expression | str(expr_string).as(file_name.to_sym)
        end
      end
    end
  end
end
