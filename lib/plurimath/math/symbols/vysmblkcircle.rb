module Plurimath
  module Math
    module Symbols
      class Vysmblkcircle < Symbol
        INPUT = {
          unicodemath: [["bullet", "&#x2219;"], parsing_wrapper(["vysmblkcircle"])],
          asciimath: [["&#x2219;"], parsing_wrapper(["bullet", "vysmblkcircle"])],
          mathml: ["&#x2219;"],
          latex: [["vysmblkcircle", "&#x2219;"], parsing_wrapper(["bullet"])],
          omml: ["&#x2219;"],
          html: ["&#x2219;"],
        }.freeze

        # output methods
        def to_latex
          "\\vysmblkcircle"
        end

        def to_asciimath
          parsing_wrapper("vysmblkcircle")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2219;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2219;"
        end

        def to_omml_without_math_tag(_)
          "&#x2219;"
        end

        def to_html
          "&#x2219;"
        end
      end
    end
  end
end
