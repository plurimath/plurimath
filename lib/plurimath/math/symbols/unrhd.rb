module Plurimath
  module Math
    module Symbols
      class Unrhd < Symbol
        INPUT = {
          unicodemath: [["trianglerighteq", "&#x22b5;"], parsing_wrapper(["unrhd"], lang: :unicode)],
          asciimath: [["&#x22b5;"], parsing_wrapper(["trianglerighteq", "unrhd"], lang: :asciimath)],
          mathml: ["&#x22b5;"],
          latex: [["trianglerighteq", "unrhd", "&#x22b5;"]],
          omml: ["&#x22b5;"],
          html: ["&#x22b5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\trianglerighteq"
        end

        def to_asciimath(**)
          parsing_wrapper("unrhd", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22b5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22b5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22b5;"
        end

        def to_html(**)
          "&#x22b5;"
        end
      end
    end
  end
end
