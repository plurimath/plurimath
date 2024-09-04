module Plurimath
  module Math
    module Symbols
      class Lesdot < Symbol
        INPUT = {
          unicodemath: [["&#x2a7f;"], parsing_wrapper(["lesdot"], lang: :unicode)],
          asciimath: [["&#x2a7f;"], parsing_wrapper(["lesdot"], lang: :asciimath)],
          mathml: ["&#x2a7f;"],
          latex: [["lesdot", "&#x2a7f;"]],
          omml: ["&#x2a7f;"],
          html: ["&#x2a7f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lesdot"
        end

        def to_asciimath(**)
          parsing_wrapper("lesdot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a7f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a7f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a7f;"
        end

        def to_html(**)
          "&#x2a7f;"
        end
      end
    end
  end
end
