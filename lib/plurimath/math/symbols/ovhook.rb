module Plurimath
  module Math
    module Symbols
      class Ovhook < Symbol
        INPUT = {
          unicodemath: [["&#x309;"], parsing_wrapper(["ovhook"])],
          asciimath: [["&#x309;"], parsing_wrapper(["ovhook"])],
          mathml: ["&#x309;"],
          latex: [["ovhook", "&#x309;"]],
          omml: ["&#x309;"],
          html: ["&#x309;"],
        }.freeze

        # output methods
        def to_latex
          "\\ovhook"
        end

        def to_asciimath
          parsing_wrapper("ovhook")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x309;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x309;"
        end

        def to_omml_without_math_tag(_)
          "&#x309;"
        end

        def to_html
          "&#x309;"
        end
      end
    end
  end
end
