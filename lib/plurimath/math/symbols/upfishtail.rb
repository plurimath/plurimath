module Plurimath
  module Math
    module Symbols
      class Upfishtail < Symbol
        INPUT = {
          unicodemath: [["&#x297e;"], parsing_wrapper(["upfishtail"], lang: :unicode)],
          asciimath: [["&#x297e;"], parsing_wrapper(["upfishtail"], lang: :asciimath)],
          mathml: ["&#x297e;"],
          latex: [["upfishtail", "&#x297e;"]],
          omml: ["&#x297e;"],
          html: ["&#x297e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upfishtail"
        end

        def to_asciimath(**)
          parsing_wrapper("upfishtail", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x297e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x297e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x297e;"
        end

        def to_html(**)
          "&#x297e;"
        end
      end
    end
  end
end
