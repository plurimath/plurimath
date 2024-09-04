module Plurimath
  module Math
    module Symbols
      class Enclosetriangle < Symbol
        INPUT = {
          unicodemath: [["&#x20e4;"], parsing_wrapper(["enclosetriangle"], lang: :unicode)],
          asciimath: [["&#x20e4;"], parsing_wrapper(["enclosetriangle"], lang: :asciimath)],
          mathml: ["&#x20e4;"],
          latex: [["enclosetriangle", "&#x20e4;"]],
          omml: ["&#x20e4;"],
          html: ["&#x20e4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\enclosetriangle"
        end

        def to_asciimath(**)
          parsing_wrapper("enclosetriangle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x20e4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x20e4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x20e4;"
        end

        def to_html(**)
          "&#x20e4;"
        end
      end
    end
  end
end
