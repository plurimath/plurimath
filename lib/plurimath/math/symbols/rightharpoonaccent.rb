module Plurimath
  module Math
    module Symbols
      class Rightharpoonaccent < Symbol
        INPUT = {
          unicodemath: [["&#x20d1;"], parsing_wrapper(["rightharpoonaccent"], lang: :unicode)],
          asciimath: [["&#x20d1;"], parsing_wrapper(["rightharpoonaccent"], lang: :asciimath)],
          mathml: ["&#x20d1;"],
          latex: [["rightharpoonaccent", "&#x20d1;"]],
          omml: ["&#x20d1;"],
          html: ["&#x20d1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightharpoonaccent"
        end

        def to_asciimath(**)
          parsing_wrapper("rightharpoonaccent", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x20d1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x20d1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x20d1;"
        end

        def to_html(**)
          "&#x20d1;"
        end
      end
    end
  end
end
