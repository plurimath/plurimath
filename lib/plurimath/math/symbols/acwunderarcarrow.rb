module Plurimath
  module Math
    module Symbols
      class Acwunderarcarrow < Symbol
        INPUT = {
          unicodemath: [["&#x293b;"], parsing_wrapper(["acwunderarcarrow"], lang: :unicode)],
          asciimath: [["&#x293b;"], parsing_wrapper(["acwunderarcarrow"], lang: :asciimath)],
          mathml: ["&#x293b;"],
          latex: [["acwunderarcarrow", "&#x293b;"]],
          omml: ["&#x293b;"],
          html: ["&#x293b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\acwunderarcarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("acwunderarcarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x293b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x293b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x293b;"
        end

        def to_html(**)
          "&#x293b;"
        end
      end
    end
  end
end
