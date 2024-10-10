# frozen_string_literal: true

module Plurimath
  class Mathml
    module Utility
      def mi=(value)
        return unless value

        symbol = Plurimath::Utility.symbols_class(value.text, lang: :mathml)
        if value.mathcolor || value.color
          Math::Function::Color.new(
            symbol,
            value.mathcolor || value.color
          )
        elsif value.mathbackground || value.background
          Math::Function::Color.new(
            symbol,
            value.mathbackground || value.backgroundcolor,
            { backgroundcolor: true }
          )
        else
          symbol
        end
      end

      def mrow=(value)
        Plurimath::Utility.filter_values(value)
      end
    end
  end
end
