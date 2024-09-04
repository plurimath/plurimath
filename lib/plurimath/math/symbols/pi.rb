module Plurimath
  module Math
    module Symbols
      class Pi < Symbol
        INPUT = {
          unicodemath: ["pi", "&#x3c0;", "&#x1d70b;", parsing_wrapper(["uppi"], lang: :unicode)],
          asciimath: ["pi", "&#x3c0;", "&#x1d70b;", parsing_wrapper(["uppi"], lang: :asciimath)],
          mathml: ["&#x3c0;", "&#x1d70b;"],
          latex: ["pi", "uppi", "&#x3c0;", "&#x1d70b;"],
          omml: ["&#x3c0;", "&#x1d70b;"],
          html: ["&#x3C0;", "&#x1d70b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\pi"
        end

        def to_asciimath(**)
          "pi"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3c0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3c0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3c0;"
        end

        def to_html(**)
          "&#x3C0;"
        end
      end
    end
  end
end
