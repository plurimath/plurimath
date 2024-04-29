module Plurimath
  module Math
    module Symbols
      class Dsub < Symbol
        INPUT = {
          unicodemath: [["&#x2a64;"], parsing_wrapper(["ndres", "dsub"])],
          asciimath: [["&#x2a64;"], parsing_wrapper(["ndres", "dsub"])],
          mathml: ["&#x2a64;"],
          latex: [["ndres", "dsub", "&#x2a64;"]],
          omml: ["&#x2a64;"],
          html: ["&#x2a64;"],
        }.freeze

        # output methods
        def to_latex
          "\\ndres"
        end

        def to_asciimath
          parsing_wrapper("dsub")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a64;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2a64;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a64;"
        end

        def to_html
          "&#x2a64;"
        end
      end
    end
  end
end
