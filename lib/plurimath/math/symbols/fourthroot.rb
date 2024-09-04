module Plurimath
  module Math
    module Symbols
      class Fourthroot < Symbol
        INPUT = {
          unicodemath: [["&#x221c;"], parsing_wrapper(["fourthroot"], lang: :unicode)],
          asciimath: [["&#x221c;"], parsing_wrapper(["fourthroot"], lang: :asciimath)],
          mathml: ["&#x221c;"],
          latex: [["fourthroot", "&#x221c;"]],
          omml: ["&#x221c;"],
          html: ["&#x221c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\fourthroot"
        end

        def to_asciimath(**)
          parsing_wrapper("fourthroot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x221c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x221c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x221c;"
        end

        def to_html(**)
          "&#x221c;"
        end
      end
    end
  end
end
