module Plurimath
  module Math
    module Symbols
      class Rightdotarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2911;"], parsing_wrapper(["rightdotarrow"], lang: :unicode)],
          asciimath: [["&#x2911;"], parsing_wrapper(["rightdotarrow"], lang: :asciimath)],
          mathml: ["&#x2911;"],
          latex: [["rightdotarrow", "&#x2911;"]],
          omml: ["&#x2911;"],
          html: ["&#x2911;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightdotarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("rightdotarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2911;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2911;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2911;"
        end

        def to_html(**)
          "&#x2911;"
        end
      end
    end
  end
end
