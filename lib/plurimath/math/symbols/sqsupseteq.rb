module Plurimath
  module Math
    module Symbols
      class Sqsupseteq < Symbol
        INPUT = {
          unicodemath: [["sqsupseteq", "&#x2292;"]],
          asciimath: [["&#x2292;"], parsing_wrapper(["sqsupseteq"], lang: :asciimath)],
          mathml: ["&#x2292;"],
          latex: [["sqsupseteq", "&#x2292;"]],
          omml: ["&#x2292;"],
          html: ["&#x2292;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sqsupseteq"
        end

        def to_asciimath(**)
          parsing_wrapper("sqsupseteq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2292;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2292;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2292;"
        end

        def to_html(**)
          "&#x2292;"
        end
      end
    end
  end
end
