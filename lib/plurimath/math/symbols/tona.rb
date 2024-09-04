module Plurimath
  module Math
    module Symbols
      class Tona < Symbol
        INPUT = {
          unicodemath: [["&#x2927;"], parsing_wrapper(["tona"], lang: :unicode)],
          asciimath: [["&#x2927;"], parsing_wrapper(["tona"], lang: :asciimath)],
          mathml: ["&#x2927;"],
          latex: [["tona", "&#x2927;"]],
          omml: ["&#x2927;"],
          html: ["&#x2927;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\tona"
        end

        def to_asciimath(**)
          parsing_wrapper("tona", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2927;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2927;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2927;"
        end

        def to_html(**)
          "&#x2927;"
        end
      end
    end
  end
end
