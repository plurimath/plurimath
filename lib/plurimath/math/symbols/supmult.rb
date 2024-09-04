module Plurimath
  module Math
    module Symbols
      class Supmult < Symbol
        INPUT = {
          unicodemath: [["&#x2ac2;"], parsing_wrapper(["supmult"], lang: :unicode)],
          asciimath: [["&#x2ac2;"], parsing_wrapper(["supmult"], lang: :asciimath)],
          mathml: ["&#x2ac2;"],
          latex: [["supmult", "&#x2ac2;"]],
          omml: ["&#x2ac2;"],
          html: ["&#x2ac2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\supmult"
        end

        def to_asciimath(**)
          parsing_wrapper("supmult", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ac2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ac2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ac2;"
        end

        def to_html(**)
          "&#x2ac2;"
        end
      end
    end
  end
end
