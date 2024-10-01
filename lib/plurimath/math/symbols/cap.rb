module Plurimath
  module Math
    module Symbols
      class Cap < Symbol
        INPUT = {
          unicodemath: [["cap", "&#x2229;"]],
          asciimath: [["&#x2229;", "cap"]],
          mathml: ["&#x2229;"],
          latex: [["cap", "&#x2229;"]],
          omml: ["&#x2229;"],
          html: ["&#x2229;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Cap"
        end

        def to_asciimath(**)
          parsing_wrapper("Cap", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2229;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2229;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2229;"
        end

        def to_html(**)
          "&#x2229;"
        end
      end
    end
  end
end
