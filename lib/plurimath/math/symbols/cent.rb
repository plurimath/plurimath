module Plurimath
  module Math
    module Symbols
      class Cent < Symbol
        INPUT = {
          unicodemath: [["&#xa2;"], parsing_wrapper(["mathcent", "cent"], lang: :unicode)],
          asciimath: [["&#xa2;"], parsing_wrapper(["mathcent", "cent"], lang: :asciimath)],
          mathml: ["&#xa2;"],
          latex: [["mathcent", "cent", "&#xa2;"]],
          omml: ["&#xa2;"],
          html: ["&#xa2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mathcent"
        end

        def to_asciimath(**)
          parsing_wrapper("cent", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#xa2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#xa2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#xa2;"
        end

        def to_html(**)
          "&#xa2;"
        end
      end
    end
  end
end
