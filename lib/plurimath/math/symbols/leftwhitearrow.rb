module Plurimath
  module Math
    module Symbols
      class Leftwhitearrow < Symbol
        INPUT = {
          unicodemath: [["&#x21e6;"], parsing_wrapper(["leftwhitearrow"], lang: :unicode)],
          asciimath: [["&#x21e6;"], parsing_wrapper(["leftwhitearrow"], lang: :asciimath)],
          mathml: ["&#x21e6;"],
          latex: [["leftwhitearrow", "&#x21e6;"]],
          omml: ["&#x21e6;"],
          html: ["&#x21e6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftwhitearrow"
        end

        def to_asciimath(**)
          parsing_wrapper("leftwhitearrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21e6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21e6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21e6;"
        end

        def to_html(**)
          "&#x21e6;"
        end
      end
    end
  end
end
