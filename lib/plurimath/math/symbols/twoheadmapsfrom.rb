module Plurimath
  module Math
    module Symbols
      class Twoheadmapsfrom < Symbol
        INPUT = {
          unicodemath: [["&#x2b36;"], parsing_wrapper(["twoheadmapsfrom"], lang: :unicode)],
          asciimath: [["&#x2b36;"], parsing_wrapper(["twoheadmapsfrom"], lang: :asciimath)],
          mathml: ["&#x2b36;"],
          latex: [["twoheadmapsfrom", "&#x2b36;"]],
          omml: ["&#x2b36;"],
          html: ["&#x2b36;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\twoheadmapsfrom"
        end

        def to_asciimath(**)
          parsing_wrapper("twoheadmapsfrom", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b36;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b36;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b36;"
        end

        def to_html(**)
          "&#x2b36;"
        end
      end
    end
  end
end
