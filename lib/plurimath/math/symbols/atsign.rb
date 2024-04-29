module Plurimath
  module Math
    module Symbols
      class Atsign < Symbol
        INPUT = {
          unicodemath: [["&#x40;"], parsing_wrapper(["atsign", "@"])],
          asciimath: [["&#x40;"], parsing_wrapper(["atsign", "@"])],
          mathml: ["&#x40;"],
          latex: [["atsign", "@", "&#x40;"]],
          omml: ["&#x40;"],
          html: ["&#x40;"],
        }.freeze

        # output methods
        def to_latex
          "\\atsign"
        end

        def to_asciimath
          parsing_wrapper("atsign")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x40;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x40;"
        end

        def to_omml_without_math_tag(_)
          "&#x40;"
        end

        def to_html
          "&#x40;"
        end
      end
    end
  end
end
