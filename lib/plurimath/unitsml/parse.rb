# frozen_string_literal: true

require "parslet"
require_relative "unitsdb"
module Plurimath
  class Unitsml
    class Parse < Parslet::Parser
      include Unitsml::Unitsdb

      rule(:extender) { (str("*") | str("/")).as(:extender) }
      rule(:units) { @@units ||= arr_to_expression(Unitsdb.units.keys, "units") }
      rule(:prefixes) { @@prefixes ||= arr_to_expression(Unitsdb.prefixes.keys, "prefixes") }
      rule(:dimensions) { @@dimensions ||= arr_to_expression(Unitsdb.dimensions.keys, "dimensions") }
      rule(:iteration) do
        prefixes >> units >> extender >> expression.as(:sequence) |
          units >> extender >> expression.as(:sequence) |
          prefixes >> units |
          units
      end
      rule(:expression) { iteration }

      root :expression

      def arr_to_expression(arr, file_name)
        array = arr.sort_by(&:length).reverse
        array.reduce do |expression, expr_string|
          expression = str(expression).as(file_name.to_sym) if expression.is_a?(String)
          expression | str(expr_string).as(file_name.to_sym)
        end
      end
    end
  end
end
