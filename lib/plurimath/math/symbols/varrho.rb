module Plurimath
  module Math
    module Symbols
      class Varrho < Symbol
        INPUT = {
          unicodemath: [["varrho", "&#x3f1;"], parsing_wrapper(["upvarrho"], lang: :unicode)],
          asciimath: [["&#x3f1;"], parsing_wrapper(["varrho", "upvarrho"], lang: :asciimath)],
          mathml: ["&#x3f1;"],
          latex: [["upvarrho", "varrho", "&#x3f1;"]],
          omml: ["&#x3f1;"],
          html: ["&#x3f1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upvarrho"
        end

        def to_asciimath(**)
          parsing_wrapper("varrho", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3f1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3f1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3f1;"
        end

        def to_html(**)
          "&#x3f1;"
        end
      end
    end
  end
end
