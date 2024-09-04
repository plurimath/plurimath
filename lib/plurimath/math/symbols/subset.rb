module Plurimath
  module Math
    module Symbols
      class Subset < Symbol
        INPUT = {
          unicodemath: [["Subset", "&#x22d0;"]],
          asciimath: [["&#x22d0;"], parsing_wrapper(["Subset"], lang: :asciimath)],
          mathml: ["&#x22d0;"],
          latex: [["Subset", "&#x22d0;"]],
          omml: ["&#x22d0;"],
          html: ["&#x22d0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Subset"
        end

        def to_asciimath(**)
          parsing_wrapper("Subset", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22d0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22d0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22d0;"
        end

        def to_html(**)
          "&#x22d0;"
        end
      end
    end
  end
end
