module Plurimath
  module Math
    module Symbols
      class Cire < Symbol
        INPUT = {
          unicodemath: [["&#x29c3;"], parsing_wrapper(["cirE"], lang: :unicode)],
          asciimath: [["&#x29c3;"], parsing_wrapper(["cirE"], lang: :asciimath)],
          mathml: ["&#x29c3;"],
          latex: [["cirE", "&#x29c3;"]],
          omml: ["&#x29c3;"],
          html: ["&#x29c3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\cirE"
        end

        def to_asciimath(**)
          parsing_wrapper("cirE", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29c3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29c3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29c3;"
        end

        def to_html(**)
          "&#x29c3;"
        end
      end
    end
  end
end
