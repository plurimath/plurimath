# frozen_string_literal: true

require "parslet"
module Plurimath
  class Unitsml
    class Parse < Parslet::Parser
      rule(:units) { load_yaml("/constants/units.yaml", "units" ) }
      rule(:prefixes) { load_yaml("/constants/prefixes.yaml", "prefixes" ) }
      rule(:dimensions) { load_yaml("/constants/dimensions.yaml", "dimensions" ) }
      rule(:sequence) { units | prefixes | match(/\s+|\d+|\w+/).as(:text) }
      rule(:iteration) { sequence >> iteration | sequence }
      rule(:expression) { iteration >> expression | iteration }

      root :expression

      def load_yaml(filepath, glob_var)
        glob_var = "@@#{glob_var}"
        if variable_defined?(glob_var)
          get_saved_value(glob_var)
        else
          content = YAML.load_file(File.join(__dir__, filepath)).to_json
          self.class.class_variable_set(
            glob_var,
            JSON.parse(content, symbolize_names: true)
          )
        end
      end

      def variable_defined?(glob_var)
        self.class.class_variables.include?(glob_var.to_sym)
      end

      def get_saved_value(glob_var)
        self.class.class_variable_get(glob_var)
      end
    end
  end
end
