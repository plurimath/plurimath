module Plurimath
  module Math
    module Symbols
      class Intprod < Symbol
        INPUT = {
          unicodemath: [["&#x2a3c;"], parsing_wrapper(["intprod"], lang: :unicode)],
          asciimath: [["&#x2a3c;"], parsing_wrapper(["intprod"], lang: :asciimath)],
          mathml: ["&#x2a3c;"],
          latex: [["intprod", "&#x2a3c;"]],
          omml: ["&#x2a3c;"],
          html: ["&#x2a3c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\intprod"
        end

        def to_asciimath(**)
          parsing_wrapper("intprod", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a3c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a3c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a3c;"
        end

        def to_html(**)
          "&#x2a3c;"
        end
      end
    end
  end
end
