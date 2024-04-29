module Plurimath
  module Math
    module Symbols
      class Mapstoleft < Symbol
        INPUT = {
          unicodemath: [["mapstoleft", "&#x21a4;"], parsing_wrapper(["mappedfrom", "mapsfrom"])],
          asciimath: [["&#x21a4;"], parsing_wrapper(["mapstoleft", "mappedfrom", "mapsfrom"])],
          mathml: ["&#x21a4;"],
          latex: [["mappedfrom", "mapsfrom", "&#x21a4;"], parsing_wrapper(["mapstoleft"])],
          omml: ["&#x21a4;"],
          html: ["&#x21a4;"],
        }.freeze

        # output methods
        def to_latex
          "\\mappedfrom"
        end

        def to_asciimath
          parsing_wrapper("mapstoleft")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x21a4;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x21a4;"
        end

        def to_omml_without_math_tag(_)
          "&#x21a4;"
        end

        def to_html
          "&#x21a4;"
        end
      end
    end
  end
end
