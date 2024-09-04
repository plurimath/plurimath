module Plurimath
  module Math
    module Symbols
      class Period < Symbol
        INPUT = {
          unicodemath: [["&#x2e;", "."], parsing_wrapper(["period"], lang: :unicode)],
          asciimath: [["&#x2e;", "."], parsing_wrapper(["period"], lang: :asciimath)],
          mathml: ["&#x2e;", "."],
          latex: [["period", ".", "&#x2e;"]],
          omml: ["&#x2e;", "."],
          html: ["&#x2e;", "."],
        }.freeze

        # output methods
        def to_latex(**)
          "."
        end

        def to_asciimath(**)
          "."
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x2e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2e;"
        end

        def to_html(**)
          "&#x2e;"
        end
      end
    end
  end
end
