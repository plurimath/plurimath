module Plurimath
  module Math
    module Symbols
      class Gt < Symbol
        INPUT = {
          unicodemath: [["&#x3e;", "&gt;"], parsing_wrapper([">", "gt", "greater"], lang: :unicode)],
          asciimath: [[">", "gt", "&#x3e;", "&gt;"], parsing_wrapper(["greater"], lang: :asciimath)],
          mathml: ["&#x3e;", "&gt;"],
          latex: [["greater", ">", "&#x3e;", "&gt;"], parsing_wrapper(["gt"], lang: :latex)],
          omml: ["&#x3e;", "&gt;"],
          html: ["&#x3e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gt"
        end

        def to_asciimath(**)
          ">"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3e;"
        end

        def to_html(**)
          "&#x3e;"
        end
      end
    end
  end
end
