module Plurimath
  module Math
    module Symbols
      class Virgo < Symbol
        INPUT = {
          unicodemath: [["&#x264d;"], parsing_wrapper(["virgo"])],
          asciimath: [["&#x264d;"], parsing_wrapper(["virgo"])],
          mathml: ["&#x264d;"],
          latex: [["virgo", "&#x264d;"]],
          omml: ["&#x264d;"],
          html: ["&#x264d;"],
        }.freeze

        # output methods
        def to_latex
          "\\virgo"
        end

        def to_asciimath
          parsing_wrapper("virgo")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x264d;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x264d;"
        end

        def to_omml_without_math_tag(_)
          "&#x264d;"
        end

        def to_html
          "&#x264d;"
        end
      end
    end
  end
end
