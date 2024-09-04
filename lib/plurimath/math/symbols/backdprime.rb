module Plurimath
  module Math
    module Symbols
      class Backdprime < Symbol
        INPUT = {
          unicodemath: [["&#x2036;"], parsing_wrapper(["backdprime"], lang: :unicode)],
          asciimath: [["&#x2036;"], parsing_wrapper(["backdprime"], lang: :asciimath)],
          mathml: ["&#x2036;"],
          latex: [["backdprime", "&#x2036;"]],
          omml: ["&#x2036;"],
          html: ["&#x2036;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\backdprime"
        end

        def to_asciimath(**)
          parsing_wrapper("backdprime", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2036;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2036;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2036;"
        end

        def to_html(**)
          "&#x2036;"
        end
      end
    end
  end
end
