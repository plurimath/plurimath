module Plurimath
  module Math
    module Symbols
      class Submult < Symbol
        INPUT = {
          unicodemath: [["&#x2ac1;"], parsing_wrapper(["submult"], lang: :unicode)],
          asciimath: [["&#x2ac1;"], parsing_wrapper(["submult"], lang: :asciimath)],
          mathml: ["&#x2ac1;"],
          latex: [["submult", "&#x2ac1;"]],
          omml: ["&#x2ac1;"],
          html: ["&#x2ac1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\submult"
        end

        def to_asciimath(**)
          parsing_wrapper("submult", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ac1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ac1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ac1;"
        end

        def to_html(**)
          "&#x2ac1;"
        end
      end
    end
  end
end
