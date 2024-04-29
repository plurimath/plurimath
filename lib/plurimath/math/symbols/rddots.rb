module Plurimath
  module Math
    module Symbols
      class Rddots < Symbol
        INPUT = {
          unicodemath: [["rddots", "&#x22f0;"], parsing_wrapper(["iddots", "adots"])],
          asciimath: [["&#x22f0;"], parsing_wrapper(["rddots", "iddots", "adots"])],
          mathml: ["&#x22f0;"],
          latex: [["iddots", "adots", "&#x22f0;"], parsing_wrapper(["rddots"])],
          omml: ["&#x22f0;"],
          html: ["&#x22f0;"],
        }.freeze

        # output methods
        def to_latex
          "\\iddots"
        end

        def to_asciimath
          parsing_wrapper("rddots")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x22f0;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x22f0;"
        end

        def to_omml_without_math_tag(_)
          "&#x22f0;"
        end

        def to_html
          "&#x22f0;"
        end
      end
    end
  end
end
