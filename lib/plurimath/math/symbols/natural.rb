module Plurimath
  module Math
    module Symbols
      class Natural < Symbol
        INPUT = {
          unicodemath: [["&#x266e;"], parsing_wrapper(["natural"], lang: :unicode)],
          asciimath: [["&#x266e;"], parsing_wrapper(["natural"], lang: :asciimath)],
          mathml: ["&#x266e;"],
          latex: [["natural", "&#x266e;"]],
          omml: ["&#x266e;"],
          html: ["&#x266e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\natural"
        end

        def to_asciimath(**)
          parsing_wrapper("natural", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x266e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x266e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x266e;"
        end

        def to_html(**)
          "&#x266e;"
        end
      end
    end
  end
end
