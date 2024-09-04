module Plurimath
  module Math
    module Symbols
      class Mapsup < Symbol
        INPUT = {
          unicodemath: [["&#x21a5;"], parsing_wrapper(["MapsUp", "mapsup"], lang: :unicode)],
          asciimath: [["&#x21a5;"], parsing_wrapper(["MapsUp", "mapsup"], lang: :asciimath)],
          mathml: ["&#x21a5;"],
          latex: [["MapsUp", "mapsup", "&#x21a5;"]],
          omml: ["&#x21a5;"],
          html: ["&#x21a5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\MapsUp"
        end

        def to_asciimath(**)
          parsing_wrapper("mapsup", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21a5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21a5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21a5;"
        end

        def to_html(**)
          "&#x21a5;"
        end
      end
    end
  end
end
