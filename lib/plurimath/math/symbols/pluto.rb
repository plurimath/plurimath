module Plurimath
  module Math
    module Symbols
      class Pluto < Symbol
        INPUT = {
          unicodemath: [["&#x2647;"], parsing_wrapper(["pluto", "Pluto"], lang: :unicode)],
          asciimath: [["&#x2647;"], parsing_wrapper(["pluto", "Pluto"], lang: :asciimath)],
          mathml: ["&#x2647;"],
          latex: [["pluto", "Pluto", "&#x2647;"]],
          omml: ["&#x2647;"],
          html: ["&#x2647;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\pluto"
        end

        def to_asciimath(**)
          parsing_wrapper("Pluto", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2647;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2647;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2647;"
        end

        def to_html(**)
          "&#x2647;"
        end
      end
    end
  end
end
