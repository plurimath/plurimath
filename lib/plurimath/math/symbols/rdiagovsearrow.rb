module Plurimath
  module Math
    module Symbols
      class Rdiagovsearrow < Symbol
        INPUT = {
          unicodemath: [["&#x2930;"], parsing_wrapper(["rdiagovsearrow"], lang: :unicode)],
          asciimath: [["&#x2930;"], parsing_wrapper(["rdiagovsearrow"], lang: :asciimath)],
          mathml: ["&#x2930;"],
          latex: [["rdiagovsearrow", "&#x2930;"]],
          omml: ["&#x2930;"],
          html: ["&#x2930;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rdiagovsearrow"
        end

        def to_asciimath(**)
          parsing_wrapper("rdiagovsearrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2930;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2930;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2930;"
        end

        def to_html(**)
          "&#x2930;"
        end
      end
    end
  end
end
