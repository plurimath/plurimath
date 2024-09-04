module Plurimath
  module Math
    module Symbols
      class Rangledot < Symbol
        INPUT = {
          unicodemath: [["&#x2992;"], parsing_wrapper(["rangledot"], lang: :unicode)],
          asciimath: [["&#x2992;"], parsing_wrapper(["rangledot"], lang: :asciimath)],
          mathml: ["&#x2992;"],
          latex: [["rangledot", "&#x2992;"]],
          omml: ["&#x2992;"],
          html: ["&#x2992;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rangledot"
        end

        def to_asciimath(**)
          parsing_wrapper("rangledot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2992;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2992;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2992;"
        end

        def to_html(**)
          "&#x2992;"
        end
      end
    end
  end
end
