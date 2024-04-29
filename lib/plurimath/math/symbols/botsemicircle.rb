module Plurimath
  module Math
    module Symbols
      class Botsemicircle < Symbol
        INPUT = {
          unicodemath: [["&#x25e1;"], parsing_wrapper(["botsemicircle"])],
          asciimath: [["&#x25e1;"], parsing_wrapper(["botsemicircle"])],
          mathml: ["&#x25e1;"],
          latex: [["botsemicircle", "&#x25e1;"]],
          omml: ["&#x25e1;"],
          html: ["&#x25e1;"],
        }.freeze

        # output methods
        def to_latex
          "\\botsemicircle"
        end

        def to_asciimath
          parsing_wrapper("botsemicircle")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x25e1;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x25e1;"
        end

        def to_omml_without_math_tag(_)
          "&#x25e1;"
        end

        def to_html
          "&#x25e1;"
        end
      end
    end
  end
end
