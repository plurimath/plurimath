module Plurimath
  module Math
    module Symbols
      class Boxonbox < Symbol
        INPUT = {
          unicodemath: [["&#x29c9;"], parsing_wrapper(["boxonbox"], lang: :unicode)],
          asciimath: [["&#x29c9;"], parsing_wrapper(["boxonbox"], lang: :asciimath)],
          mathml: ["&#x29c9;"],
          latex: [["boxonbox", "&#x29c9;"]],
          omml: ["&#x29c9;"],
          html: ["&#x29c9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\boxonbox"
        end

        def to_asciimath(**)
          parsing_wrapper("boxonbox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29c9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29c9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29c9;"
        end

        def to_html(**)
          "&#x29c9;"
        end
      end
    end
  end
end
