# frozen_string_literal: true

module Plurimath
  class Unitsml
    module Function
      class Unit
        attr_accessor :id,
                      :dimension_url,
                      :short,
                      :root,
                      :unit_system,
                      :unit_name,
                      :unit_symbols,
                      :root_units,
                      :quantity_reference

        def initialize(id,
                       dimension_url,
                       short = {},
                       root,
                       unit_system,
                       unit_name,
                       unit_symbols,
                       root_units,
                       quantity_reference)
          @id = id
          @dimension_url = dimension_url
          @short = short
          @root = root
          @unit_system = unit_system
          @unit_name = unit_name
          @unit_symbols = unit_symbols
          @root_units = root_units
          @quantity_reference = quantity_reference
        end
      end
    end
  end
end
