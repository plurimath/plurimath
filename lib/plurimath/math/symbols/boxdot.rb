module Plurimath
  module Math
    module Symbols
      class Boxdot < Symbol
        INPUT = {
          unicodemath: [["boxdot", "&#x22a1;"]],
          asciimath: [["&#x22a1;"], parsing_wrapper(["boxdot"], lang: :asciimath)],
          mathml: ["&#x22a1;"],
          latex: [["boxdot", "&#x22a1;"]],
          omml: ["&#x22a1;"],
          html: ["&#x22a1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\boxdot"
        end

        def to_asciimath(**)
          parsing_wrapper("boxdot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22a1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22a1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22a1;"
        end

        def to_html(**)
          "&#x22a1;"
        end
      end
    end
  end
end
