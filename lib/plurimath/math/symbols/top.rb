module Plurimath
  module Math
    module Symbols
      class Top < Symbol
        INPUT = {
          unicodemath: [["top", "&#x22a4;"], parsing_wrapper(["TT"], lang: :unicode)],
          asciimath: [["top", "TT", "&#x22a4;"]],
          mathml: ["&#x22a4;"],
          latex: [["top", "&#x22a4;"], parsing_wrapper(["TT"], lang: :latex)],
          omml: ["&#x22a4;"],
          html: ["&#x22a4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\top"
        end

        def to_asciimath(**)
          parsing_wrapper("top", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22a4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22a4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22a4;"
        end

        def to_html(**)
          "&#x22a4;"
        end
      end
    end
  end
end
