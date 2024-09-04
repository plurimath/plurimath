module Plurimath
  module Math
    module Symbols
      class Barleftarrow < Symbol
        INPUT = {
          unicodemath: [["&#x21e4;"], parsing_wrapper(["LeftArrowBar", "barleftarrow"], lang: :unicode)],
          asciimath: [["&#x21e4;"], parsing_wrapper(["LeftArrowBar", "barleftarrow"], lang: :asciimath)],
          mathml: ["&#x21e4;"],
          latex: [["LeftArrowBar", "barleftarrow", "&#x21e4;"]],
          omml: ["&#x21e4;"],
          html: ["&#x21e4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\LeftArrowBar"
        end

        def to_asciimath(**)
          parsing_wrapper("barleftarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21e4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21e4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21e4;"
        end

        def to_html(**)
          "&#x21e4;"
        end
      end
    end
  end
end
