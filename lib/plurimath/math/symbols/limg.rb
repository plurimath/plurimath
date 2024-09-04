module Plurimath
  module Math
    module Symbols
      class Limg < Symbol
        INPUT = {
          unicodemath: [["&#x2987;"], parsing_wrapper(["llparenthesis", "limg"], lang: :unicode)],
          asciimath: [["&#x2987;"], parsing_wrapper(["llparenthesis", "limg"], lang: :asciimath)],
          mathml: ["&#x2987;"],
          latex: [["llparenthesis", "limg", "&#x2987;"]],
          omml: ["&#x2987;"],
          html: ["&#x2987;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\llparenthesis"
        end

        def to_asciimath(**)
          parsing_wrapper("limg", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2987;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2987;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2987;"
        end

        def to_html(**)
          "&#x2987;"
        end
      end
    end
  end
end
