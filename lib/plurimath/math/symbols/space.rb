module Plurimath
  module Math
    module Symbols
      class Space < Symbol
        INPUT = {
          unicodemath: [["&#xa0;"], parsing_wrapper(["\\ "], lang: :unicode)],
          asciimath: [["\\ ", "&#xa0;"]],
          mathml: ["&#xa0;"],
          latex: [["&#xa0;"], parsing_wrapper(["\\ "], lang: :latex)],
          omml: ["&#xa0;"],
          html: ["&#xa0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ "
        end

        def to_asciimath(**)
          "\\ "
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#xa0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#xa0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#xa0;"
        end

        def to_html(**)
          "&#xa0;"
        end
      end
    end
  end
end
