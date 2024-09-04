module Plurimath
  module Math
    module Symbols
      class Longmapsfrom < Symbol
        INPUT = {
          unicodemath: [["&#x27fd;"], parsing_wrapper(["Longmappedfrom", "Longmapsfrom"], lang: :unicode)],
          asciimath: [["&#x27fd;"], parsing_wrapper(["Longmappedfrom", "Longmapsfrom"], lang: :asciimath)],
          mathml: ["&#x27fd;"],
          latex: [["Longmappedfrom", "Longmapsfrom", "&#x27fd;"]],
          omml: ["&#x27fd;"],
          html: ["&#x27fd;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Longmappedfrom"
        end

        def to_asciimath(**)
          parsing_wrapper("Longmapsfrom", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27fd;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27fd;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27fd;"
        end

        def to_html(**)
          "&#x27fd;"
        end
      end
    end
  end
end
