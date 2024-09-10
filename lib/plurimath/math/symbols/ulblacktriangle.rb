module Plurimath
  module Math
    module Symbols
      class Ulblacktriangle < Symbol
        INPUT = {
          unicodemath: [["&#x25e4;"], parsing_wrapper(["ulblacktriangle"], lang: :unicode)],
          asciimath: [["&#x25e4;"], parsing_wrapper(["ulblacktriangle"], lang: :asciimath)],
          mathml: ["&#x25e4;"],
          latex: [["ulblacktriangle", "&#x25e4;"]],
          omml: ["&#x25e4;"],
          html: ["&#x25e4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ulblacktriangle"
        end

        def to_asciimath(**)
          parsing_wrapper("ulblacktriangle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25e4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25e4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25e4;"
        end

        def to_html(**)
          "&#x25e4;"
        end
      end
    end
  end
end
