# frozen_string_literal: true

require "yaml"
require "parslet"
module Plurimath
  class Unitsml
    module Unitsdb
      class << self
        def load_yaml(file_name)
          var_name = "@@#{file_name}"
          if variable_defined?(var_name)
            get_saved_value(var_name)
          else
            files = Dir.glob(File.join("**/constants/#{file_name}.yaml"))
            set_class_variable(var_name, YAML.load_file(files.first))
          end
        end

        def units
          @@units ||= units_hash
        end

        def prefixes
          @@prefixes ||= prefixes_hash
        end

        def dimensions
          @@dimensions ||= dimensions_hash
        end

        def units_hash
          @@units_hash ||= unit_ids(load_yaml("units"))
        end

        def prefixes_hash
          @@prefixes_hash ||= prefix_ids(load_yaml("prefixes"))
        end

        def dimensions_hash
          @@dimensions_hash ||= dimensions_ids(load_yaml("dimensions"))
        end

        def get_saved_value(variable_name)
          self
            .class
            .class_variable_get(variable_name)
        end

        def set_class_variable(var_name, content)
          self
            .class
            .class_variable_set(var_name, content)
        end

        def variable_defined?(variable_name)
          self
            .class
            .class_variables
            .include?(variable_name.to_sym)
        end

        def unit_ids(hash, symbols = {})
          hash.each do |key, value|
            value["unit_symbols"]&.each do |symbol|
              symbols[symbol["id"]] = { key => value } unless symbol["id"]&.empty?
            end
          end
          symbols
        end

        def prefix_ids(prefixes, hash = {})
          prefixes.map do |key, value|
            symbol = value.dig("symbol", "ascii")
            hash[symbol] = { id: key, fields: value } unless symbol&.empty?
          end
          hash
        end
      end
    end
  end
end
