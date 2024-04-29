module Plurimath
  module Math
    module Symbols
      class Nsub < Symbol
        INPUT = {
          unicodemath: [["nsub", "&#x2284;"], parsing_wrapper(["nsubset"])],
          asciimath: [["&#x2284;"], parsing_wrapper(["nsub", "nsubset"])],
          mathml: ["&#x2284;"],
          latex: [["nsubset", "&#x2284;"], parsing_wrapper(["nsub"])],
          omml: ["&#x2284;"],
          html: ["&#x2284;"],
        }.freeze

        # output methods
        def to_latex
          "\\nsubset"
        end

        def to_asciimath
          parsing_wrapper("nsub")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2284;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2284;"
        end

        def to_omml_without_math_tag(_)
          "&#x2284;"
        end

        def to_html
          "&#x2284;"
        end
      end
    end
  end
end
