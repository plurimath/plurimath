module Plurimath
  module Math
    module Symbols
      class Eqeq < Symbol
        INPUT = {
          unicodemath: [["&#x2a75;"], parsing_wrapper(["Equal", "eqeq"], lang: :unicode)],
          asciimath: [["&#x2a75;"], parsing_wrapper(["Equal", "eqeq"], lang: :asciimath)],
          mathml: ["&#x2a75;"],
          latex: [["Equal", "eqeq", "&#x2a75;"]],
          omml: ["&#x2a75;"],
          html: ["&#x2a75;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\eqeq"
        end

        def to_asciimath(**)
          parsing_wrapper("eqeq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a75;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a75;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a75;"
        end

        def to_html(**)
          "&#x2a75;"
        end
      end
    end
  end
end
