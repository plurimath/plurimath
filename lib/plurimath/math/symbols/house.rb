module Plurimath
  module Math
    module Symbols
      class House < Symbol
        INPUT = {
          unicodemath: [["&#x2302;"], parsing_wrapper(["house"], lang: :unicode)],
          asciimath: [["&#x2302;"], parsing_wrapper(["house"], lang: :asciimath)],
          mathml: ["&#x2302;"],
          latex: [["house", "&#x2302;"]],
          omml: ["&#x2302;"],
          html: ["&#x2302;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\house"
        end

        def to_asciimath(**)
          parsing_wrapper("house", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2302;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2302;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2302;"
        end

        def to_html(**)
          "&#x2302;"
        end
      end
    end
  end
end
