module Plurimath
  module Math
    module Symbols
      class Aplrightarrowbox < Symbol
        INPUT = {
          unicodemath: [["&#x2348;"], parsing_wrapper(["APLrightarrowbox"])],
          asciimath: [["&#x2348;"], parsing_wrapper(["APLrightarrowbox"])],
          mathml: ["&#x2348;"],
          latex: [["APLrightarrowbox", "&#x2348;"]],
          omml: ["&#x2348;"],
          html: ["&#x2348;"],
        }.freeze

        # output methods
        def to_latex
          "\\APLrightarrowbox"
        end

        def to_asciimath
          parsing_wrapper("APLrightarrowbox")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2348;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2348;"
        end

        def to_omml_without_math_tag(_)
          "&#x2348;"
        end

        def to_html
          "&#x2348;"
        end
      end
    end
  end
end
