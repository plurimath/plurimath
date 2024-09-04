module Plurimath
  module Math
    module Symbols
      class Boxbslash < Symbol
        INPUT = {
          unicodemath: [["&#x29c5;"], parsing_wrapper(["boxbslash"], lang: :unicode)],
          asciimath: [["&#x29c5;"], parsing_wrapper(["boxbslash"], lang: :asciimath)],
          mathml: ["&#x29c5;"],
          latex: [["boxbslash", "&#x29c5;"]],
          omml: ["&#x29c5;"],
          html: ["&#x29c5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\boxbslash"
        end

        def to_asciimath(**)
          parsing_wrapper("boxbslash", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29c5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29c5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29c5;"
        end

        def to_html(**)
          "&#x29c5;"
        end
      end
    end
  end
end
