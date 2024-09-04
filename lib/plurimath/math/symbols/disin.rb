module Plurimath
  module Math
    module Symbols
      class Disin < Symbol
        INPUT = {
          unicodemath: [["&#x22f2;"], parsing_wrapper(["disin"], lang: :unicode)],
          asciimath: [["&#x22f2;"], parsing_wrapper(["disin"], lang: :asciimath)],
          mathml: ["&#x22f2;"],
          latex: [["disin", "&#x22f2;"]],
          omml: ["&#x22f2;"],
          html: ["&#x22f2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\disin"
        end

        def to_asciimath(**)
          parsing_wrapper("disin", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22f2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22f2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22f2;"
        end

        def to_html(**)
          "&#x22f2;"
        end
      end
    end
  end
end
