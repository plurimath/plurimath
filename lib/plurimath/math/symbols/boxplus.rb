module Plurimath
  module Math
    module Symbols
      class Boxplus < Symbol
        INPUT = {
          unicodemath: [["boxplus", "&#x229e;"]],
          asciimath: [["&#x229e;"], parsing_wrapper(["boxplus"], lang: :asciimath)],
          mathml: ["&#x229e;"],
          latex: [["boxplus", "&#x229e;"]],
          omml: ["&#x229e;"],
          html: ["&#x229e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\boxplus"
        end

        def to_asciimath(**)
          parsing_wrapper("boxplus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x229e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x229e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x229e;"
        end

        def to_html(**)
          "&#x229e;"
        end
      end
    end
  end
end
