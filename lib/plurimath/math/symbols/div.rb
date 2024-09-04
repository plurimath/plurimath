module Plurimath
  module Math
    module Symbols
      class Div < Symbol
        INPUT = {
          unicodemath: [["div", "&#xf7;"], parsing_wrapper(["-:"], lang: :unicode)],
          asciimath: [["-:", "div", "&#xf7;"]],
          mathml: ["&#xf7;"],
          latex: [["div", "&#xf7;"], parsing_wrapper(["-:"], lang: :latex)],
          omml: ["&#xf7;"],
          html: ["&#xf7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\div"
        end

        def to_asciimath(**)
          "-:"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#xf7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#xf7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#xf7;"
        end

        def to_html(**)
          "&#xf7;"
        end
      end
    end
  end
end
