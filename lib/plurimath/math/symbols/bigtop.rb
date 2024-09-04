module Plurimath
  module Math
    module Symbols
      class Bigtop < Symbol
        INPUT = {
          unicodemath: [["&#x27d9;"], parsing_wrapper(["bigtop"], lang: :unicode)],
          asciimath: [["&#x27d9;"], parsing_wrapper(["bigtop"], lang: :asciimath)],
          mathml: ["&#x27d9;"],
          latex: [["bigtop", "&#x27d9;"]],
          omml: ["&#x27d9;"],
          html: ["&#x27d9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigtop"
        end

        def to_asciimath(**)
          parsing_wrapper("bigtop", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27d9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27d9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27d9;"
        end

        def to_html(**)
          "&#x27d9;"
        end
      end
    end
  end
end
