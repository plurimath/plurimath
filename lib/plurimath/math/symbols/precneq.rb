module Plurimath
  module Math
    module Symbols
      class Precneq < Symbol
        INPUT = {
          unicodemath: [["&#x2ab1;"], parsing_wrapper(["precneq"], lang: :unicode)],
          asciimath: [["&#x2ab1;"], parsing_wrapper(["precneq"], lang: :asciimath)],
          mathml: ["&#x2ab1;"],
          latex: [["precneq", "&#x2ab1;"]],
          omml: ["&#x2ab1;"],
          html: ["&#x2ab1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\precneq"
        end

        def to_asciimath(**)
          parsing_wrapper("precneq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ab1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ab1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ab1;"
        end

        def to_html(**)
          "&#x2ab1;"
        end
      end
    end
  end
end
