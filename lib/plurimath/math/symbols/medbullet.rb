module Plurimath
  module Math
    module Symbols
      class Medbullet < Symbol
        INPUT = {
          unicodemath: [["&#x26ab;"], parsing_wrapper(["mdblkcircle", "medbullet"])],
          asciimath: [["&#x26ab;"], parsing_wrapper(["mdblkcircle", "medbullet"])],
          mathml: ["&#x26ab;"],
          latex: [["mdblkcircle", "medbullet", "&#x26ab;"]],
          omml: ["&#x26ab;"],
          html: ["&#x26ab;"],
        }.freeze

        # output methods
        def to_latex
          "\\mdblkcircle"
        end

        def to_asciimath
          parsing_wrapper("medbullet")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x26ab;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x26ab;"
        end

        def to_omml_without_math_tag(_)
          "&#x26ab;"
        end

        def to_html
          "&#x26ab;"
        end
      end
    end
  end
end
