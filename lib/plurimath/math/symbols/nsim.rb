module Plurimath
  module Math
    module Symbols
      class Nsim < Symbol
        INPUT = {
          unicodemath: [["nsim", "&#x2241;"]],
          asciimath: [["&#x2241;"], parsing_wrapper(["nsim"], lang: :asciimath)],
          mathml: ["&#x2241;"],
          latex: [["nsim", "&#x2241;"]],
          omml: ["&#x2241;"],
          html: ["&#x2241;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nsim"
        end

        def to_asciimath(**)
          parsing_wrapper("nsim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2241;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2241;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2241;"
        end

        def to_html(**)
          "&#x2241;"
        end
      end
    end
  end
end
