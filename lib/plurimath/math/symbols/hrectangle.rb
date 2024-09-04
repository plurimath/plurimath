module Plurimath
  module Math
    module Symbols
      class Hrectangle < Symbol
        INPUT = {
          unicodemath: [["&#x25ad;"], parsing_wrapper(["hrectangle"], lang: :unicode)],
          asciimath: [["&#x25ad;"], parsing_wrapper(["hrectangle"], lang: :asciimath)],
          mathml: ["&#x25ad;"],
          latex: [["hrectangle", "&#x25ad;"]],
          omml: ["&#x25ad;"],
          html: ["&#x25ad;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\hrectangle"
        end

        def to_asciimath(**)
          parsing_wrapper("hrectangle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25ad;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25ad;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25ad;"
        end

        def to_html(**)
          "&#x25ad;"
        end
      end
    end
  end
end
