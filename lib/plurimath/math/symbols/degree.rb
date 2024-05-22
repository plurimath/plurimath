module Plurimath
  module Math
    module Symbols
      class Degree < Symbol
        INPUT = {
          unicodemath: [["degree", "&#xb0;"]],
          asciimath: [["&#xb0;"], parsing_wrapper(["degree"])],
          mathml: ["&#xb0;"],
          latex: [["&#xb0;"], parsing_wrapper(["degree"])],
          omml: ["&#xb0;"],
          html: ["&#xb0;"],
        }.freeze

        # output methods
        def to_latex
          parsing_wrapper("degree")
        end

        def to_asciimath
          parsing_wrapper("degree")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#xb0;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mi") << "&#xb0;"
        end

        def to_omml_without_math_tag(_)
          "&#xb0;"
        end

        def to_html
          "&#xb0;"
        end
      end
    end
  end
end
