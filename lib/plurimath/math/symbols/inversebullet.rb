module Plurimath
  module Math
    module Symbols
      class Inversebullet < Symbol
        INPUT = {
          unicodemath: [["&#x25d8;"], parsing_wrapper(["inversebullet"], lang: :unicode)],
          asciimath: [["&#x25d8;"], parsing_wrapper(["inversebullet"], lang: :asciimath)],
          mathml: ["&#x25d8;"],
          latex: [["inversebullet", "&#x25d8;"]],
          omml: ["&#x25d8;"],
          html: ["&#x25d8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\inversebullet"
        end

        def to_asciimath(**)
          parsing_wrapper("inversebullet", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25d8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25d8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25d8;"
        end

        def to_html(**)
          "&#x25d8;"
        end
      end
    end
  end
end
