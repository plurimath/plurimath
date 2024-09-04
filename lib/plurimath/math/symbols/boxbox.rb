module Plurimath
  module Math
    module Symbols
      class Boxbox < Symbol
        INPUT = {
          unicodemath: [["&#x29c8;"], parsing_wrapper(["boxbox"], lang: :unicode)],
          asciimath: [["&#x29c8;"], parsing_wrapper(["boxbox"], lang: :asciimath)],
          mathml: ["&#x29c8;"],
          latex: [["boxbox", "&#x29c8;"]],
          omml: ["&#x29c8;"],
          html: ["&#x29c8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\boxbox"
        end

        def to_asciimath(**)
          parsing_wrapper("boxbox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29c8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29c8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29c8;"
        end

        def to_html(**)
          "&#x29c8;"
        end
      end
    end
  end
end
