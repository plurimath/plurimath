module Plurimath
  module Math
    module Symbols
      class Sampi < Symbol
        INPUT = {
          unicodemath: [["&#x3e1;"], parsing_wrapper(["upsampi", "sampi"], lang: :unicode)],
          asciimath: [["&#x3e1;"], parsing_wrapper(["upsampi", "sampi"], lang: :asciimath)],
          mathml: ["&#x3e1;"],
          latex: [["upsampi", "sampi", "&#x3e1;"]],
          omml: ["&#x3e1;"],
          html: ["&#x3e1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upsampi"
        end

        def to_asciimath(**)
          parsing_wrapper("sampi", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3e1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3e1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3e1;"
        end

        def to_html(**)
          "&#x3e1;"
        end
      end
    end
  end
end
