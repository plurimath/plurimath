module Plurimath
  module Math
    module Symbols
      class Ubrace < Symbol
        INPUT = {
          unicodemath: [["&#x23df;"]],
          asciimath: [["&#x23df;"]],
          mathml: ["&#x23df;"],
          latex: [["&#x23df;"]],
          omml: ["&#x23df;"],
          html: ["&#x23df;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ubrace"
        end

        def to_asciimath(**)
          "ubrace"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23df;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23df;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23df;"
        end

        def to_html(**)
          "&#x23df;"
        end
      end
    end
  end
end
