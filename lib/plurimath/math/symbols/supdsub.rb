module Plurimath
  module Math
    module Symbols
      class Supdsub < Symbol
        INPUT = {
          unicodemath: [["&#x2ad8;"], parsing_wrapper(["supdsub"])],
          asciimath: [["&#x2ad8;"], parsing_wrapper(["supdsub"])],
          mathml: ["&#x2ad8;"],
          latex: [["supdsub", "&#x2ad8;"]],
          omml: ["&#x2ad8;"],
          html: ["&#x2ad8;"],
        }.freeze

        # output methods
        def to_latex
          "\\supdsub"
        end

        def to_asciimath
          parsing_wrapper("supdsub")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2ad8;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2ad8;"
        end

        def to_omml_without_math_tag(_)
          "&#x2ad8;"
        end

        def to_html
          "&#x2ad8;"
        end
      end
    end
  end
end
