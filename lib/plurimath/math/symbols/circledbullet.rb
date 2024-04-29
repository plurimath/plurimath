module Plurimath
  module Math
    module Symbols
      class Circledbullet < Symbol
        INPUT = {
          unicodemath: [["&#x29bf;"], parsing_wrapper(["circledbullet"])],
          asciimath: [["&#x29bf;"], parsing_wrapper(["circledbullet"])],
          mathml: ["&#x29bf;"],
          latex: [["circledbullet", "&#x29bf;"]],
          omml: ["&#x29bf;"],
          html: ["&#x29bf;"],
        }.freeze

        # output methods
        def to_latex
          "\\circledbullet"
        end

        def to_asciimath
          parsing_wrapper("circledbullet")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29bf;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29bf;"
        end

        def to_omml_without_math_tag(_)
          "&#x29bf;"
        end

        def to_html
          "&#x29bf;"
        end
      end
    end
  end
end
