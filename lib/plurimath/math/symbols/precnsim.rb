module Plurimath
  module Math
    module Symbols
      class Precnsim < Symbol
        INPUT = {
          unicodemath: [["precnsim", "&#x22e8;"]],
          asciimath: [["&#x22e8;"], parsing_wrapper(["precnsim"], lang: :asciimath)],
          mathml: ["&#x22e8;"],
          latex: [["precnsim", "&#x22e8;"]],
          omml: ["&#x22e8;"],
          html: ["&#x22e8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\precnsim"
        end

        def to_asciimath(**)
          parsing_wrapper("precnsim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22e8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22e8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22e8;"
        end

        def to_html(**)
          "&#x22e8;"
        end
      end
    end
  end
end
