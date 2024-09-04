module Plurimath
  module Math
    module Symbols
      class Gle < Symbol
        INPUT = {
          unicodemath: [["&#x2a92;"], parsing_wrapper(["glE"], lang: :unicode)],
          asciimath: [["&#x2a92;"], parsing_wrapper(["glE"], lang: :asciimath)],
          mathml: ["&#x2a92;"],
          latex: [["glE", "&#x2a92;"]],
          omml: ["&#x2a92;"],
          html: ["&#x2a92;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\glE"
        end

        def to_asciimath(**)
          parsing_wrapper("glE", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a92;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a92;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a92;"
        end

        def to_html(**)
          "&#x2a92;"
        end
      end
    end
  end
end
