module Plurimath
  module Math
    module Symbols
      class Barleftarrowrightarrowba < Symbol
        INPUT = {
          unicodemath: [["&#x21b9;"], parsing_wrapper(["barleftarrowrightarrowba"], lang: :unicode)],
          asciimath: [["&#x21b9;"], parsing_wrapper(["barleftarrowrightarrowba"], lang: :asciimath)],
          mathml: ["&#x21b9;"],
          latex: [["barleftarrowrightarrowba", "&#x21b9;"]],
          omml: ["&#x21b9;"],
          html: ["&#x21b9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\barleftarrowrightarrowba"
        end

        def to_asciimath(**)
          parsing_wrapper("barleftarrowrightarrowba", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21b9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21b9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21b9;"
        end

        def to_html(**)
          "&#x21b9;"
        end
      end
    end
  end
end
