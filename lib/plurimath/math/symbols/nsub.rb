module Plurimath
  module Math
    module Symbols
      class Nsub < Symbol
        INPUT = {
          unicodemath: [["nsub", "&#x2284;"], parsing_wrapper(["nsubset"], lang: :unicode)],
          asciimath: [["&#x2284;"], parsing_wrapper(["nsub", "nsubset"], lang: :asciimath)],
          mathml: ["&#x2284;"],
          latex: [["nsubset", "&#x2284;"], parsing_wrapper(["nsub"], lang: :latex)],
          omml: ["&#x2284;"],
          html: ["&#x2284;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nsubset"
        end

        def to_asciimath(**)
          parsing_wrapper("nsub", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2284;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2284;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2284;"
        end

        def to_html(**)
          "&#x2284;"
        end
      end
    end
  end
end
