module Plurimath
  module Math
    module Symbols
      class Medbullet < Symbol
        INPUT = {
          unicodemath: [["&#x26ab;"], parsing_wrapper(["mdblkcircle", "medbullet"], lang: :unicode)],
          asciimath: [["&#x26ab;"], parsing_wrapper(["mdblkcircle", "medbullet"], lang: :asciimath)],
          mathml: ["&#x26ab;"],
          latex: [["mdblkcircle", "medbullet", "&#x26ab;"]],
          omml: ["&#x26ab;"],
          html: ["&#x26ab;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mdblkcircle"
        end

        def to_asciimath(**)
          parsing_wrapper("medbullet", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x26ab;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x26ab;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x26ab;"
        end

        def to_html(**)
          "&#x26ab;"
        end
      end
    end
  end
end
