module Plurimath
  module Math
    module Symbols
      class Mapsfrom < Symbol
        INPUT = {
          unicodemath: [["&#x2906;"], parsing_wrapper(["Mappedfrom", "Mapsfrom"], lang: :unicode)],
          asciimath: [["&#x2906;"], parsing_wrapper(["Mappedfrom", "Mapsfrom"], lang: :asciimath)],
          mathml: ["&#x2906;"],
          latex: [["Mappedfrom", "Mapsfrom", "&#x2906;"]],
          omml: ["&#x2906;"],
          html: ["&#x2906;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Mappedfrom"
        end

        def to_asciimath(**)
          parsing_wrapper("Mapsfrom", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2906;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2906;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2906;"
        end

        def to_html(**)
          "&#x2906;"
        end
      end
    end
  end
end
