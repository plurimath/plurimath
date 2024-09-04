module Plurimath
  module Math
    module Symbols
      class Awint < Symbol
        INPUT = {
          unicodemath: [["&#x2a11;"], parsing_wrapper(["awint"], lang: :unicode)],
          asciimath: [["&#x2a11;"], parsing_wrapper(["awint"], lang: :asciimath)],
          mathml: ["&#x2a11;"],
          latex: [["awint", "&#x2a11;"]],
          omml: ["&#x2a11;"],
          html: ["&#x2a11;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\awint"
        end

        def to_asciimath(**)
          parsing_wrapper("awint", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a11;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a11;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a11;"
        end

        def to_html(**)
          "&#x2a11;"
        end
      end
    end
  end
end
