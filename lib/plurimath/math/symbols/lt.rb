module Plurimath
  module Math
    module Symbols
      class Lt < Symbol
        INPUT = {
          unicodemath: [["&#x3c;", "&lt;"], parsing_wrapper(["<", "lt", "less"], lang: :unicode)],
          asciimath: [["<", "lt", "&#x3c;", "&lt;"], parsing_wrapper(["less"], lang: :asciimath)],
          mathml: ["&#x3c;", "&lt;"],
          latex: [["less", "<", "&#x3c;", "&lt;"], parsing_wrapper(["lt"], lang: :latex)],
          omml: ["&#x3c;", "&lt;"],
          html: ["&#x3c;"],
        }.freeze

        # output methods
        def to_latex
          "\\lt"
        end

        def to_asciimath
          "lt"
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x3c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3c;"
        end

        def to_omml_without_math_tag(_)
          "&#x3c;"
        end

        def to_html
          "&#x3c;"
        end
      end
    end
  end
end
