module Plurimath
  module Math
    module Symbols
      class Congdot < Symbol
        INPUT = {
          unicodemath: [["&#x2a6d;"], parsing_wrapper(["congdot"], lang: :unicode)],
          asciimath: [["&#x2a6d;"], parsing_wrapper(["congdot"], lang: :asciimath)],
          mathml: ["&#x2a6d;"],
          latex: [["congdot", "&#x2a6d;"]],
          omml: ["&#x2a6d;"],
          html: ["&#x2a6d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\congdot"
        end

        def to_asciimath(**)
          parsing_wrapper("congdot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a6d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a6d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a6d;"
        end

        def to_html(**)
          "&#x2a6d;"
        end
      end
    end
  end
end
