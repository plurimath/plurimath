module Plurimath
  module Math
    module Symbols
      class Nexi < Symbol
        INPUT = {
          unicodemath: [["nexists", "&#x2204;"], parsing_wrapper(["nexi"], lang: :unicode)],
          asciimath: [["&#x2204;"], parsing_wrapper(["nexists", "nexi"], lang: :asciimath)],
          mathml: ["&#x2204;"],
          latex: [["nexists", "nexi", "&#x2204;"]],
          omml: ["&#x2204;"],
          html: ["&#x2204;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nexists"
        end

        def to_asciimath(**)
          parsing_wrapper("nexi", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2204;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2204;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2204;"
        end

        def to_html(**)
          "&#x2204;"
        end
      end
    end
  end
end
