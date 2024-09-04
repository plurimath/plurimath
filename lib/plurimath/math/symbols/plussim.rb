module Plurimath
  module Math
    module Symbols
      class Plussim < Symbol
        INPUT = {
          unicodemath: [["&#x2a26;"], parsing_wrapper(["plussim"], lang: :unicode)],
          asciimath: [["&#x2a26;"], parsing_wrapper(["plussim"], lang: :asciimath)],
          mathml: ["&#x2a26;"],
          latex: [["plussim", "&#x2a26;"]],
          omml: ["&#x2a26;"],
          html: ["&#x2a26;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\plussim"
        end

        def to_asciimath(**)
          parsing_wrapper("plussim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a26;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a26;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a26;"
        end

        def to_html(**)
          "&#x2a26;"
        end
      end
    end
  end
end
