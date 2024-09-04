module Plurimath
  module Math
    module Symbols
      class Nsup < Symbol
        INPUT = {
          unicodemath: [["nsup", "&#x2285;"], parsing_wrapper(["nsupset"], lang: :unicode)],
          asciimath: [["&#x2285;"], parsing_wrapper(["nsup", "nsupset"], lang: :asciimath)],
          mathml: ["&#x2285;"],
          latex: [["nsupset", "&#x2285;"], parsing_wrapper(["nsup"], lang: :latex)],
          omml: ["&#x2285;"],
          html: ["&#x2285;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nsupset"
        end

        def to_asciimath(**)
          parsing_wrapper("nsup", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2285;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2285;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2285;"
        end

        def to_html(**)
          "&#x2285;"
        end
      end
    end
  end
end
