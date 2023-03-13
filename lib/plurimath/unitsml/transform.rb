# frozen_string_literal: true

require "parslet"
module Plurimath
  class Unitsml
    class Transform < Parslet::Transform
      rule(prefixes: simple(:prefix),
           units: simple(:unit)) do
        Math::Formula.new(
          [
            Utility.prefix(Unitsdb.prefixes_hash[prefix.to_s]),
            Utility.unit(Unitsdb.units_hash[unit.to_s]),
          ],
        )
      end

      rule(prefixes: simple(:prefix),
           units: simple(:unit),
           extender: simple(:extender),
           sequence: simple(:sequence)) do
        Math::Formula.new(
          [
            Utility.prefix(
              Unitsdb.prefixes_hash[prefix.to_s],
            ),
            Utility.unit(
              Unitsdb.units_hash[unit.to_s],
            ),
            Function::Extender.new(extender.to_s),
            sequence,
          ],
        )
      end

      rule(units: simple(:unit)) { Utility.unit(Unitsdb.units_hash[unit.to_s]) }
    end
  end
end
