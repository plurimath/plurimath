module Plurimath
  module Math
    module Symbols
      class Bigodot < Symbol
        INPUT = {
          unicodemath: [["&#x2a00;"], parsing_wrapper(["bigodot"], lang: :unicode)],
          asciimath: [["&#x2a00;"], parsing_wrapper(["bigodot"], lang: :asciimath)],
          mathml: ["&#x2a00;"],
          latex: [["bigodot", "&#x2a00;"]],
          omml: ["&#x2a00;"],
          html: ["&#x2a00;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigodot"
        end

        def to_asciimath(**)
          parsing_wrapper("bigodot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a00;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a00;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a00;"
        end

        def to_html(**)
          "&#x2a00;"
        end
      end
    end
  end
end
