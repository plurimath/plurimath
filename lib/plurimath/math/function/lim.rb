# frozen_string_literal: true

require_relative "binary_function"

module Plurimath
  module Math
    module Function
      class Lim < BinaryFunction
        def to_asciimath
          first_value = "_(#{parameter_one.to_asciimath})" if parameter_one
          second_value = "^(#{parameter_two.to_asciimath})" if parameter_two
          "lim#{first_value}#{second_value}"
        end

        def to_latex
          first_value = "_{#{parameter_one.to_latex}}" if parameter_one
          second_value = "^{#{parameter_two.to_latex}}" if parameter_two
          "\\#{class_name}#{first_value}#{second_value}"
        end

        def to_omml_without_math_tag
          <<~OMML
            <m:limUpp>
              <m:limUppPr>
                <m:ctrlPr>
                  <w:rPr>
                    <w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/>
                    <w:i/>
                  </w:rPr>
                </m:ctrlPr>
              </m:limUppPr>
              <m:e>#{parameter_one.to_omml_without_math_tag}</m:e>
              <m:lim>#{parameter_two.to_omml_without_math_tag}</m:lim>
            </m:limUpp>
          OMML
        end
      end
    end
  end
end
