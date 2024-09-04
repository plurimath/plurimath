module Plurimath
  module Math
    module Symbols
      class Downfishtail < Symbol
        INPUT = {
          unicodemath: [["&#x297f;"], parsing_wrapper(["downfishtail"], lang: :unicode)],
          asciimath: [["&#x297f;"], parsing_wrapper(["downfishtail"], lang: :asciimath)],
          mathml: ["&#x297f;"],
          latex: [["downfishtail", "&#x297f;"]],
          omml: ["&#x297f;"],
          html: ["&#x297f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\downfishtail"
        end

        def to_asciimath(**)
          parsing_wrapper("downfishtail", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x297f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x297f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x297f;"
        end

        def to_html(**)
          "&#x297f;"
        end
      end
    end
  end
end
