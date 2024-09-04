module Plurimath
  module Math
    module Symbols
      class Vvv < Symbol
        INPUT = {
          unicodemath: [["&#x22c1;"], parsing_wrapper(["bigvee", "vvv"], lang: :unicode)],
          asciimath: [["bigvee", "vvv", "&#x22c1;"]],
          mathml: ["&#x22c1;"],
          latex: [["bigvee", "&#x22c1;"], parsing_wrapper(["vvv"], lang: :latex)],
          omml: ["&#x22c1;"],
          html: ["&#x22c1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigvee"
        end

        def to_asciimath(**)
          "bigvee"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22c1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x22c1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22c1;"
        end

        def to_html(**)
          "&#x22c1;"
        end
      end
    end
  end
end
