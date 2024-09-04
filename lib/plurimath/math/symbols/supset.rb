module Plurimath
  module Math
    module Symbols
      class Supset < Symbol
        INPUT = {
          unicodemath: [["Supset", "&#x22d1;"]],
          asciimath: [["&#x22d1;"], parsing_wrapper(["Supset"], lang: :asciimath)],
          mathml: ["&#x22d1;"],
          latex: [["Supset", "&#x22d1;"]],
          omml: ["&#x22d1;"],
          html: ["&#x22d1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Supset"
        end

        def to_asciimath(**)
          parsing_wrapper("Supset", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22d1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22d1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22d1;"
        end

        def to_html(**)
          "&#x22d1;"
        end
      end
    end
  end
end
