module Plurimath
  module Math
    module Symbols
      class Boxtimes < Symbol
        INPUT = {
          unicodemath: [["boxtimes", "&#x22a0;"]],
          asciimath: [["&#x22a0;"], parsing_wrapper(["boxtimes"], lang: :asciimath)],
          mathml: ["&#x22a0;"],
          latex: [["boxtimes", "&#x22a0;"]],
          omml: ["&#x22a0;"],
          html: ["&#x22a0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\boxtimes"
        end

        def to_asciimath(**)
          parsing_wrapper("boxtimes", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22a0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22a0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22a0;"
        end

        def to_html(**)
          "&#x22a0;"
        end
      end
    end
  end
end
