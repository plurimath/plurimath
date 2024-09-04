module Plurimath
  module Math
    module Symbols
      class Downleftvectorbar < Symbol
        INPUT = {
          unicodemath: [["&#x2956;"], parsing_wrapper(["barleftharpoondown", "DownLeftVectorBar"], lang: :unicode)],
          asciimath: [["&#x2956;"], parsing_wrapper(["barleftharpoondown", "DownLeftVectorBar"], lang: :asciimath)],
          mathml: ["&#x2956;"],
          latex: [["barleftharpoondown", "DownLeftVectorBar", "&#x2956;"]],
          omml: ["&#x2956;"],
          html: ["&#x2956;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\barleftharpoondown"
        end

        def to_asciimath(**)
          parsing_wrapper("DownLeftVectorBar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2956;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2956;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2956;"
        end

        def to_html(**)
          "&#x2956;"
        end
      end
    end
  end
end
