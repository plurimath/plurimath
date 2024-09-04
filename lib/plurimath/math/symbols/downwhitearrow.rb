module Plurimath
  module Math
    module Symbols
      class Downwhitearrow < Symbol
        INPUT = {
          unicodemath: [["&#x21e9;"], parsing_wrapper(["downwhitearrow"], lang: :unicode)],
          asciimath: [["&#x21e9;"], parsing_wrapper(["downwhitearrow"], lang: :asciimath)],
          mathml: ["&#x21e9;"],
          latex: [["downwhitearrow", "&#x21e9;"]],
          omml: ["&#x21e9;"],
          html: ["&#x21e9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\downwhitearrow"
        end

        def to_asciimath(**)
          parsing_wrapper("downwhitearrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21e9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21e9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21e9;"
        end

        def to_html(**)
          "&#x21e9;"
        end
      end
    end
  end
end
