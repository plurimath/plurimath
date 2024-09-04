module Plurimath
  module Math
    module Symbols
      class Bigotimes < Symbol
        INPUT = {
          unicodemath: [["&#x2a02;"], parsing_wrapper(["bigotimes"], lang: :unicode)],
          asciimath: [["&#x2a02;"], parsing_wrapper(["bigotimes"], lang: :asciimath)],
          mathml: ["&#x2a02;"],
          latex: [["bigotimes", "&#x2a02;"]],
          omml: ["&#x2a02;"],
          html: ["&#x2a02;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigotimes"
        end

        def to_asciimath(**)
          parsing_wrapper("bigotimes", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a02;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a02;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a02;"
        end

        def to_html(**)
          "&#x2a02;"
        end
      end
    end
  end
end
