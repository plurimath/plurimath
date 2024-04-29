module Plurimath
  module Math
    module Symbols
      class Colon < Symbol
        INPUT = {
          unicodemath: [["colon", "&#x2236;"], parsing_wrapper(["mathratio"])],
          asciimath: [["&#x2236;"], parsing_wrapper(["colon", "mathratio"])],
          mathml: ["&#x2236;"],
          latex: [["mathratio", "&#x2236;"], parsing_wrapper(["colon"])],
          omml: ["&#x2236;"],
          html: ["&#x2236;"],
        }.freeze

        # output methods
        def to_latex
          "\\mathratio"
        end

        def to_asciimath
          parsing_wrapper("colon")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2236;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2236;"
        end

        def to_omml_without_math_tag(_)
          "&#x2236;"
        end

        def to_html
          "&#x2236;"
        end
      end
    end
  end
end
