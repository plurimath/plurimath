module Plurimath
  module Math
    module Symbols
      class Baruparrow < Symbol
        INPUT = {
          unicodemath: [["&#x2912;"], parsing_wrapper(["UpArrowBar", "baruparrow"], lang: :unicode)],
          asciimath: [["&#x2912;"], parsing_wrapper(["UpArrowBar", "baruparrow"], lang: :asciimath)],
          mathml: ["&#x2912;"],
          latex: [["UpArrowBar", "baruparrow", "&#x2912;"]],
          omml: ["&#x2912;"],
          html: ["&#x2912;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\UpArrowBar"
        end

        def to_asciimath(**)
          parsing_wrapper("baruparrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2912;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2912;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2912;"
        end

        def to_html(**)
          "&#x2912;"
        end
      end
    end
  end
end
