module Plurimath
  module Math
    module Symbols
      class Nsime < Symbol
        INPUT = {
          unicodemath: [["nsimeq", "&#x2244;"], parsing_wrapper(["nsime"], lang: :unicode)],
          asciimath: [["&#x2244;"], parsing_wrapper(["nsimeq", "nsime"], lang: :asciimath)],
          mathml: ["&#x2244;"],
          latex: [["nsimeq", "nsime", "&#x2244;"]],
          omml: ["&#x2244;"],
          html: ["&#x2244;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nsimeq"
        end

        def to_asciimath(**)
          parsing_wrapper("nsime", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2244;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2244;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2244;"
        end

        def to_html(**)
          "&#x2244;"
        end
      end
    end
  end
end
