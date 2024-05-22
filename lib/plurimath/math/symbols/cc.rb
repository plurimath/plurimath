module Plurimath
  module Math
    module Symbols
      class Cc < Symbol
        INPUT = {
          unicodemath: [["&#x2102;"], parsing_wrapper(["CC"])],
          asciimath: [["&#x2102;"], parsing_wrapper(["CC"])],
          mathml: ["&#x2102;"],
          latex: [["CC", "&#x2102;"]],
          omml: ["&#x2102;"],
          html: ["&#x2102;"],
        }.freeze

        # output methods
        def to_latex
          "\\CC"
        end

        def to_asciimath
          parsing_wrapper("CC")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2102;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mi") << "&#x2102;"
        end

        def to_omml_without_math_tag(_)
          "&#x2102;"
        end

        def to_html
          "&#x2102;"
        end
      end
    end
  end
end
