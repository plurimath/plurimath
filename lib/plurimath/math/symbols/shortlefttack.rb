module Plurimath
  module Math
    module Symbols
      class Shortlefttack < Symbol
        INPUT = {
          unicodemath: [["&#x2ade;"], parsing_wrapper(["shortlefttack"], lang: :unicode)],
          asciimath: [["&#x2ade;"], parsing_wrapper(["shortlefttack"], lang: :asciimath)],
          mathml: ["&#x2ade;"],
          latex: [["shortlefttack", "&#x2ade;"]],
          omml: ["&#x2ade;"],
          html: ["&#x2ade;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\shortlefttack"
        end

        def to_asciimath(**)
          parsing_wrapper("shortlefttack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ade;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ade;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ade;"
        end

        def to_html(**)
          "&#x2ade;"
        end
      end
    end
  end
end
