module Plurimath
  module Math
    module Symbols
      class Threedotcolon < Symbol
        INPUT = {
          unicodemath: [["&#x2af6;"], parsing_wrapper(["threedotcolon"], lang: :unicode)],
          asciimath: [["&#x2af6;"], parsing_wrapper(["threedotcolon"], lang: :asciimath)],
          mathml: ["&#x2af6;"],
          latex: [["threedotcolon", "&#x2af6;"]],
          omml: ["&#x2af6;"],
          html: ["&#x2af6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\threedotcolon"
        end

        def to_asciimath(**)
          parsing_wrapper("threedotcolon", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2af6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2af6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2af6;"
        end

        def to_html(**)
          "&#x2af6;"
        end
      end
    end
  end
end
