module Plurimath
  module Math
    module Symbols
      class Xbox < Symbol
        INPUT = {
          unicodemath: [["&#x2612;"], parsing_wrapper(["XBox"], lang: :unicode)],
          asciimath: [["&#x2612;"], parsing_wrapper(["XBox"], lang: :asciimath)],
          mathml: ["&#x2612;"],
          latex: [["XBox", "&#x2612;"]],
          omml: ["&#x2612;"],
          html: ["&#x2612;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\XBox"
        end

        def to_asciimath(**)
          parsing_wrapper("XBox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2612;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2612;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2612;"
        end

        def to_html(**)
          "&#x2612;"
        end
      end
    end
  end
end
