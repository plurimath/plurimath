module Plurimath
  module Math
    module Symbols
      class Squarecrossfill < Symbol
        INPUT = {
          unicodemath: [["&#x25a9;"], parsing_wrapper(["squarecrossfill"], lang: :unicode)],
          asciimath: [["&#x25a9;"], parsing_wrapper(["squarecrossfill"], lang: :asciimath)],
          mathml: ["&#x25a9;"],
          latex: [["squarecrossfill", "&#x25a9;"]],
          omml: ["&#x25a9;"],
          html: ["&#x25a9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\squarecrossfill"
        end

        def to_asciimath(**)
          parsing_wrapper("squarecrossfill", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25a9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25a9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25a9;"
        end

        def to_html(**)
          "&#x25a9;"
        end
      end
    end
  end
end
