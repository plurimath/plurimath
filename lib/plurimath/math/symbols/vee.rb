module Plurimath
  module Math
    module Symbols
      class Vee < Symbol
        INPUT = {
          unicodemath: [["&#x2a54;"], parsing_wrapper(["Vee"], lang: :unicode)],
          asciimath: [["&#x2a54;"], parsing_wrapper(["Vee"], lang: :asciimath)],
          mathml: ["&#x2a54;"],
          latex: [["Vee", "&#x2a54;"]],
          omml: ["&#x2a54;"],
          html: ["&#x2a54;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Vee"
        end

        def to_asciimath(**)
          parsing_wrapper("Vee", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a54;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a54;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a54;"
        end

        def to_html(**)
          "&#x2a54;"
        end
      end
    end
  end
end
