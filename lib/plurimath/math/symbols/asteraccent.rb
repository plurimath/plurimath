module Plurimath
  module Math
    module Symbols
      class Asteraccent < Symbol
        INPUT = {
          unicodemath: [["&#x20f0;"], parsing_wrapper(["asteraccent"], lang: :unicode)],
          asciimath: [["&#x20f0;"], parsing_wrapper(["asteraccent"], lang: :asciimath)],
          mathml: ["&#x20f0;"],
          latex: [["asteraccent", "&#x20f0;"]],
          omml: ["&#x20f0;"],
          html: ["&#x20f0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\asteraccent"
        end

        def to_asciimath(**)
          parsing_wrapper("asteraccent", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x20f0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x20f0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x20f0;"
        end

        def to_html(**)
          "&#x20f0;"
        end
      end
    end
  end
end
