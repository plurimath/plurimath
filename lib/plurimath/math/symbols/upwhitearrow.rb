module Plurimath
  module Math
    module Symbols
      class Upwhitearrow < Symbol
        INPUT = {
          unicodemath: [["&#x21e7;"], parsing_wrapper(["upwhitearrow"], lang: :unicode)],
          asciimath: [["&#x21e7;"], parsing_wrapper(["upwhitearrow"], lang: :asciimath)],
          mathml: ["&#x21e7;"],
          latex: [["upwhitearrow", "&#x21e7;"]],
          omml: ["&#x21e7;"],
          html: ["&#x21e7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upwhitearrow"
        end

        def to_asciimath(**)
          parsing_wrapper("upwhitearrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21e7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21e7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21e7;"
        end

        def to_html(**)
          "&#x21e7;"
        end
      end
    end
  end
end
