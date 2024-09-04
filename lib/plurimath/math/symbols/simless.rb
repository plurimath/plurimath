module Plurimath
  module Math
    module Symbols
      class Simless < Symbol
        INPUT = {
          unicodemath: [["&#x2a9d;"], parsing_wrapper(["simless"], lang: :unicode)],
          asciimath: [["&#x2a9d;"], parsing_wrapper(["simless"], lang: :asciimath)],
          mathml: ["&#x2a9d;"],
          latex: [["simless", "&#x2a9d;"]],
          omml: ["&#x2a9d;"],
          html: ["&#x2a9d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\simless"
        end

        def to_asciimath(**)
          parsing_wrapper("simless", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a9d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a9d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a9d;"
        end

        def to_html(**)
          "&#x2a9d;"
        end
      end
    end
  end
end
