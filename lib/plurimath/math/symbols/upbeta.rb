module Plurimath
  module Math
    module Symbols
      class Upbeta < Symbol
        INPUT = {
          unicodemath: [["&#x3b2;"], parsing_wrapper(["beta", "upbeta"], lang: :unicode)],
          asciimath: [["beta", "&#x3b2;"], parsing_wrapper(["upbeta"], lang: :asciimath)],
          mathml: ["&#x3b2;"],
          latex: [["upbeta", "beta", "&#x3b2;"]],
          omml: ["&#x3b2;"],
          html: ["&#x3b2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\beta"
        end

        def to_asciimath(**)
          "beta"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3b2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3b2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3b2;"
        end

        def to_html(**)
          "&#x3b2;"
        end
      end
    end
  end
end
