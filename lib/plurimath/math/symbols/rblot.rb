module Plurimath
  module Math
    module Symbols
      class Rblot < Symbol
        INPUT = {
          unicodemath: [["&#x298a;"], parsing_wrapper(["rrangle", "rblot"])],
          asciimath: [["&#x298a;"], parsing_wrapper(["rrangle", "rblot"])],
          mathml: ["&#x298a;"],
          latex: [["rrangle", "rblot", "&#x298a;"]],
          omml: ["&#x298a;"],
          html: ["&#x298a;"],
        }.freeze

        # output methods
        def to_latex
          "\\rrangle"
        end

        def to_asciimath
          parsing_wrapper("rblot")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x298a;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x298a;"
        end

        def to_omml_without_math_tag(_)
          "&#x298a;"
        end

        def to_html
          "&#x298a;"
        end
      end
    end
  end
end
