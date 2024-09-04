module Plurimath
  module Math
    module Symbols
      class Aplinput < Symbol
        INPUT = {
          unicodemath: [["&#x235e;"], parsing_wrapper(["APLinput"], lang: :unicode)],
          asciimath: [["&#x235e;"], parsing_wrapper(["APLinput"], lang: :asciimath)],
          mathml: ["&#x235e;"],
          latex: [["APLinput", "&#x235e;"]],
          omml: ["&#x235e;"],
          html: ["&#x235e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\APLinput"
        end

        def to_asciimath(**)
          parsing_wrapper("APLinput", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x235e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x235e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x235e;"
        end

        def to_html(**)
          "&#x235e;"
        end
      end
    end
  end
end
