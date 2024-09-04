module Plurimath
  module Math
    module Symbols
      class Neovsearrow < Symbol
        INPUT = {
          unicodemath: [["&#x292e;"], parsing_wrapper(["neovsearrow"], lang: :unicode)],
          asciimath: [["&#x292e;"], parsing_wrapper(["neovsearrow"], lang: :asciimath)],
          mathml: ["&#x292e;"],
          latex: [["neovsearrow", "&#x292e;"]],
          omml: ["&#x292e;"],
          html: ["&#x292e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\neovsearrow"
        end

        def to_asciimath(**)
          parsing_wrapper("neovsearrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x292e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x292e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x292e;"
        end

        def to_html(**)
          "&#x292e;"
        end
      end
    end
  end
end
