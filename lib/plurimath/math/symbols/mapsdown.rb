module Plurimath
  module Math
    module Symbols
      class Mapsdown < Symbol
        INPUT = {
          unicodemath: [["&#x21a7;"], parsing_wrapper(["MapsDown", "mapsdown"], lang: :unicode)],
          asciimath: [["&#x21a7;"], parsing_wrapper(["MapsDown", "mapsdown"], lang: :asciimath)],
          mathml: ["&#x21a7;"],
          latex: [["MapsDown", "mapsdown", "&#x21a7;"]],
          omml: ["&#x21a7;"],
          html: ["&#x21a7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\MapsDown"
        end

        def to_asciimath(**)
          parsing_wrapper("mapsdown", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21a7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21a7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21a7;"
        end

        def to_html(**)
          "&#x21a7;"
        end
      end
    end
  end
end
