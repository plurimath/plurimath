module Plurimath
  module Math
    module Symbols
      class Aplcomment < Symbol
        INPUT = {
          unicodemath: [["&#x235d;"], parsing_wrapper(["APLcomment"], lang: :unicode)],
          asciimath: [["&#x235d;"], parsing_wrapper(["APLcomment"], lang: :asciimath)],
          mathml: ["&#x235d;"],
          latex: [["APLcomment", "&#x235d;"]],
          omml: ["&#x235d;"],
          html: ["&#x235d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\APLcomment"
        end

        def to_asciimath(**)
          parsing_wrapper("APLcomment", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x235d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x235d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x235d;"
        end

        def to_html(**)
          "&#x235d;"
        end
      end
    end
  end
end
