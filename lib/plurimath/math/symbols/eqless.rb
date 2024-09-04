module Plurimath
  module Math
    module Symbols
      class Eqless < Symbol
        INPUT = {
          unicodemath: [["&#x22dc;"], parsing_wrapper(["eqless"], lang: :unicode)],
          asciimath: [["&#x22dc;"], parsing_wrapper(["eqless"], lang: :asciimath)],
          mathml: ["&#x22dc;"],
          latex: [["eqless", "&#x22dc;"]],
          omml: ["&#x22dc;"],
          html: ["&#x22dc;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\eqless"
        end

        def to_asciimath(**)
          parsing_wrapper("eqless", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22dc;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22dc;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22dc;"
        end

        def to_html(**)
          "&#x22dc;"
        end
      end
    end
  end
end
