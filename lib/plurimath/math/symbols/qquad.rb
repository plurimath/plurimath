module Plurimath
  module Math
    module Symbols
      class Qquad < Symbol
        INPUT = {
          unicodemath: [["&#xa0;&#xa0;&#xa0;&#xa0;"], parsing_wrapper(["qquad"], lang: :unicode)],
          asciimath: [["&#xa0;&#xa0;&#xa0;&#xa0;"], parsing_wrapper(["qquad"], lang: :asciimath)],
          mathml: ["&#xa0;&#xa0;&#xa0;&#xa0;"],
          latex: [["qquad", "&#xa0;&#xa0;&#xa0;&#xa0;"]],
          omml: ["&#xa0;&#xa0;&#xa0;&#xa0;"],
          html: ["&#xa0;&#xa0;&#xa0;&#xa0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\qquad"
        end

        def to_asciimath(**)
          parsing_wrapper("qquad", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#xa0;&#xa0;&#xa0;&#xa0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#xa0;&#xa0;&#xa0;&#xa0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#xa0;&#xa0;&#xa0;&#xa0;"
        end

        def to_html(**)
          "&#xa0;&#xa0;&#xa0;&#xa0;"
        end
      end
    end
  end
end
