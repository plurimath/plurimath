module Plurimath
  module Math
    module Symbols
      class Spadesuit < Symbol
        INPUT = {
          unicodemath: [["spadesuit", "&#x2660;"]],
          asciimath: [["&#x2660;"], parsing_wrapper(["spadesuit"], lang: :asciimath)],
          mathml: ["&#x2660;"],
          latex: [["spadesuit", "&#x2660;"]],
          omml: ["&#x2660;"],
          html: ["&#x2660;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\spadesuit"
        end

        def to_asciimath(**)
          parsing_wrapper("spadesuit", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2660;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2660;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2660;"
        end

        def to_html(**)
          "&#x2660;"
        end
      end
    end
  end
end
