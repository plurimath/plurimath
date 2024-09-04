module Plurimath
  module Math
    module Symbols
      class Lsime < Symbol
        INPUT = {
          unicodemath: [["&#x2a8d;"], parsing_wrapper(["lsime"], lang: :unicode)],
          asciimath: [["&#x2a8d;"], parsing_wrapper(["lsime"], lang: :asciimath)],
          mathml: ["&#x2a8d;"],
          latex: [["lsime", "&#x2a8d;"]],
          omml: ["&#x2a8d;"],
          html: ["&#x2a8d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lsime"
        end

        def to_asciimath(**)
          parsing_wrapper("lsime", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a8d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a8d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a8d;"
        end

        def to_html(**)
          "&#x2a8d;"
        end
      end
    end
  end
end
