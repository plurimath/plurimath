module Plurimath
  module Math
    module Symbols
      class Divideontimes < Symbol
        INPUT = {
          unicodemath: [["divideontimes", "&#xc7;"]],
          asciimath: [["&#xc7;"], parsing_wrapper(["divideontimes"])],
          mathml: ["&#xc7;"],
          latex: [["&#xc7;"], parsing_wrapper(["divideontimes"])],
          omml: ["&#xc7;"],
          html: ["&#xc7;"],
        }.freeze

        # output methods
        def to_latex
          parsing_wrapper("divideontimes")
        end

        def to_asciimath
          parsing_wrapper("divideontimes")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#xc7;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#xc7;"
        end

        def to_omml_without_math_tag(_)
          "&#xc7;"
        end

        def to_html
          "&#xc7;"
        end
      end
    end
  end
end
