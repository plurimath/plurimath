# frozen_string_literal: true

require "parslet"
module Plurimath
  class Unitsml
    class Parse < Parslet::Parser
      rule(:extender) { str("*") | str("/") }
      rule(:units) { load_yaml("units") }
      rule(:prefixes) { load_yaml("prefixes") }
      rule(:dimensions) { load_yaml("dimensions") }
      rule(:iteration) { units | prefixes >> units | prefixes >> units >> extender >> expression | units >> extender >> expression }
      rule(:expression) { iteration }

      root :expression

      def load_yaml(file_name)
        var_name = "@@#{file_name}"
        if variable_defined?(var_name)
          get_saved_value(var_name)
        else
          files = Dir.glob(File.join("**/constants/#{file_name}.yaml"))
          hash_to_expression(var_name, YAML.load_file(files.first), file_name)
        end
      end

      def variable_defined?(variable_name)
        self.class.class_variables.include?(variable_name.to_sym)
      end

      def get_saved_value(variable_name)
        self.class.class_variable_get(variable_name)
      end

      def set_class_variable(var_name, content)
        self
          .class
          .class_variable_set(var_name, content)
      end

      def hash_to_expression(var_name, hash, file_name)
        symbols = []
        if var_name.include?("units")
          unit_ids(hash, symbols)
        elsif var_name.include?("prefixes")
          prefix_ids(hash, symbols)
        end
        set_class_variable(var_name, arr_to_expression(symbols, file_name))
      end

      def unit_ids(hash, symbols)
        hash.each do |_, value|
          value["unit_symbols"]&.each do |symbol|
            symbols << symbol["id"]
          end
        end
      end

      def prefix_ids(hash, symbols)
        hash.each { |_, value| symbols << value["symbol"]["ascii"] }
      end

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
