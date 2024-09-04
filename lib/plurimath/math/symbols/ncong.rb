module Plurimath
  module Math
    module Symbols
      class Ncong < Symbol
        INPUT = {
          unicodemath: [["ncong", "&#x2247;"]],
          asciimath: [["&#x2247;"], parsing_wrapper(["ncong"], lang: :asciimath)],
          mathml: ["&#x2247;"],
          latex: [["ncong", "&#x2247;"]],
          omml: ["&#x2247;"],
          html: ["&#x2247;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ncong"
        end

        def to_asciimath(**)
          parsing_wrapper("ncong", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2247;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2247;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2247;"
        end

        def to_html(**)
          "&#x2247;"
        end
      end
    end
  end
end
