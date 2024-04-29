module Plurimath
  module Math
    module Symbols
      class Dag < Symbol
        INPUT = {
          unicodemath: [["dag", "&#x2020;"], parsing_wrapper(["dagger"])],
          asciimath: [["&#x2020;"], parsing_wrapper(["dag", "dagger"])],
          mathml: ["&#x2020;"],
          latex: [["dagger", "&#x2020;"], parsing_wrapper(["dag"])],
          omml: ["&#x2020;"],
          html: ["&#x2020;"],
        }.freeze

        # output methods
        def to_latex
          "\\dagger"
        end

        def to_asciimath
          parsing_wrapper("dag")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2020;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2020;"
        end

        def to_omml_without_math_tag(_)
          "&#x2020;"
        end

        def to_html
          "&#x2020;"
        end
      end
    end
  end
end
