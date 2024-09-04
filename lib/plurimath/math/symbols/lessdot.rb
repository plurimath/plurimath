module Plurimath
  module Math
    module Symbols
      class Lessdot < Symbol
        INPUT = {
          unicodemath: [["lessdot", "&#x22d6;"]],
          asciimath: [["&#x22d6;"], parsing_wrapper(["lessdot"], lang: :asciimath)],
          mathml: ["&#x22d6;"],
          latex: [["lessdot", "&#x22d6;"]],
          omml: ["&#x22d6;"],
          html: ["&#x22d6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lessdot"
        end

        def to_asciimath(**)
          parsing_wrapper("lessdot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22d6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22d6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22d6;"
        end

        def to_html(**)
          "&#x22d6;"
        end
      end
    end
  end
end
