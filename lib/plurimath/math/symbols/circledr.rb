module Plurimath
  module Math
    module Symbols
      class Circledr < Symbol
        INPUT = {
          unicodemath: [["&#xae;"], parsing_wrapper(["circledR"], lang: :unicode)],
          asciimath: [["&#xae;"], parsing_wrapper(["circledR"], lang: :asciimath)],
          mathml: ["&#xae;"],
          latex: [["circledR", "&#xae;"]],
          omml: ["&#xae;"],
          html: ["&#xae;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circledR"
        end

        def to_asciimath(**)
          parsing_wrapper("circledR", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#xae;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#xae;"
        end

        def to_omml_without_math_tag(_, **)
          "&#xae;"
        end

        def to_html(**)
          "&#xae;"
        end
      end
    end
  end
end
