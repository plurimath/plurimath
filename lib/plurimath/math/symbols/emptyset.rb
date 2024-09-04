module Plurimath
  module Math
    module Symbols
      class Emptyset < Symbol
        INPUT = {
          unicodemath: [["emptyset", "&#x2205;"], parsing_wrapper(["O/", "varnothing"], lang: :unicode)],
          asciimath: [["emptyset", "O/", "&#x2205;"], parsing_wrapper(["varnothing"], lang: :asciimath)],
          mathml: ["&#x2205;"],
          latex: [["varnothing", "emptyset", "&#x2205;"], parsing_wrapper(["O/"], lang: :latex)],
          omml: ["&#x2205;"],
          html: ["&#x2205;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varnothing"
        end

        def to_asciimath(**)
          parsing_wrapper("emptyset", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2205;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2205;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2205;"
        end

        def to_html(**)
          "&#x2205;"
        end
      end
    end
  end
end
