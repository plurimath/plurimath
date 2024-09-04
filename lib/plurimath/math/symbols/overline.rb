module Plurimath
  module Math
    module Symbols
      class Overline < Symbol
        INPUT = {
          unicodemath: [["&#x203e;"]],
          asciimath: [["&#x203e;"]],
          mathml: ["&#x203e;"],
          latex: [["&#x203e;"]],
          omml: ["&#x203e;"],
          html: ["&#x203e;"],
        }.freeze

        # output methods
        def to_latex(**)
          parsing_wrapper("overline", lang: :latex)
        end

        def to_asciimath(**)
          parsing_wrapper("overline", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x203e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x203e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x203e;"
        end

        def to_html(**)
          "&#x203e;"
        end
      end
    end
  end
end
