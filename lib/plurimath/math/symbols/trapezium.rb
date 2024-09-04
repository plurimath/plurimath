module Plurimath
  module Math
    module Symbols
      class Trapezium < Symbol
        INPUT = {
          unicodemath: [["&#x23e2;"], parsing_wrapper(["trapezium"], lang: :unicode)],
          asciimath: [["&#x23e2;"], parsing_wrapper(["trapezium"], lang: :asciimath)],
          mathml: ["&#x23e2;"],
          latex: [["trapezium", "&#x23e2;"]],
          omml: ["&#x23e2;"],
          html: ["&#x23e2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\trapezium"
        end

        def to_asciimath(**)
          parsing_wrapper("trapezium", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23e2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23e2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23e2;"
        end

        def to_html(**)
          "&#x23e2;"
        end
      end
    end
  end
end
