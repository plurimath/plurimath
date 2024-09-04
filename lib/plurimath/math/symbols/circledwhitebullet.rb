module Plurimath
  module Math
    module Symbols
      class Circledwhitebullet < Symbol
        INPUT = {
          unicodemath: [["&#x29be;"], parsing_wrapper(["circledwhitebullet"], lang: :unicode)],
          asciimath: [["&#x29be;"], parsing_wrapper(["circledwhitebullet"], lang: :asciimath)],
          mathml: ["&#x29be;"],
          latex: [["circledwhitebullet", "&#x29be;"]],
          omml: ["&#x29be;"],
          html: ["&#x29be;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circledwhitebullet"
        end

        def to_asciimath(**)
          parsing_wrapper("circledwhitebullet", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29be;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29be;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29be;"
        end

        def to_html(**)
          "&#x29be;"
        end
      end
    end
  end
end
