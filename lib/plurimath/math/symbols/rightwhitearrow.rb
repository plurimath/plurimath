module Plurimath
  module Math
    module Symbols
      class Rightwhitearrow < Symbol
        INPUT = {
          unicodemath: [["&#x21e8;"], parsing_wrapper(["rightwhitearrow"], lang: :unicode)],
          asciimath: [["&#x21e8;"], parsing_wrapper(["rightwhitearrow"], lang: :asciimath)],
          mathml: ["&#x21e8;"],
          latex: [["rightwhitearrow", "&#x21e8;"]],
          omml: ["&#x21e8;"],
          html: ["&#x21e8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightwhitearrow"
        end

        def to_asciimath(**)
          parsing_wrapper("rightwhitearrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21e8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21e8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21e8;"
        end

        def to_html(**)
          "&#x21e8;"
        end
      end
    end
  end
end
