module Plurimath
  module Math
    module Symbols
      class Topfork < Symbol
        INPUT = {
          unicodemath: [["&#x2ada;"], parsing_wrapper(["topfork"], lang: :unicode)],
          asciimath: [["&#x2ada;"], parsing_wrapper(["topfork"], lang: :asciimath)],
          mathml: ["&#x2ada;"],
          latex: [["topfork", "&#x2ada;"]],
          omml: ["&#x2ada;"],
          html: ["&#x2ada;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\topfork"
        end

        def to_asciimath(**)
          parsing_wrapper("topfork", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ada;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ada;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ada;"
        end

        def to_html(**)
          "&#x2ada;"
        end
      end
    end
  end
end
