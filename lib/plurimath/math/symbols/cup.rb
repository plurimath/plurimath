module Plurimath
  module Math
    module Symbols
      class Cup < Symbol
        INPUT = {
          unicodemath: [["Cup", "&#x22d3;"]],
          asciimath: [["&#x22d3;"], parsing_wrapper(["Cup"], lang: :asciimath)],
          mathml: ["&#x22d3;"],
          latex: [["Cup", "&#x22d3;"]],
          omml: ["&#x22d3;"],
          html: ["&#x22d3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Cup"
        end

        def to_asciimath(**)
          parsing_wrapper("Cup", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22d3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22d3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22d3;"
        end

        def to_html(**)
          "&#x22d3;"
        end
      end
    end
  end
end
