module Plurimath
  module Math
    module Symbols
      class Intlarhk < Symbol
        INPUT = {
          unicodemath: [["&#x2a17;"], parsing_wrapper(["intlarhk"], lang: :unicode)],
          asciimath: [["&#x2a17;"], parsing_wrapper(["intlarhk"], lang: :asciimath)],
          mathml: ["&#x2a17;"],
          latex: [["intlarhk", "&#x2a17;"]],
          omml: ["&#x2a17;"],
          html: ["&#x2a17;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\intlarhk"
        end

        def to_asciimath(**)
          parsing_wrapper("intlarhk", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a17;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a17;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a17;"
        end

        def to_html(**)
          "&#x2a17;"
        end
      end
    end
  end
end
