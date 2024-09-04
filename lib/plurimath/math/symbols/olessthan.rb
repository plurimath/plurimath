module Plurimath
  module Math
    module Symbols
      class Olessthan < Symbol
        INPUT = {
          unicodemath: [["&#x29c0;"], parsing_wrapper(["circledless", "olessthan"], lang: :unicode)],
          asciimath: [["&#x29c0;"], parsing_wrapper(["circledless", "olessthan"], lang: :asciimath)],
          mathml: ["&#x29c0;"],
          latex: [["circledless", "olessthan", "&#x29c0;"]],
          omml: ["&#x29c0;"],
          html: ["&#x29c0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circledless"
        end

        def to_asciimath(**)
          parsing_wrapper("olessthan", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29c0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29c0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29c0;"
        end

        def to_html(**)
          "&#x29c0;"
        end
      end
    end
  end
end
