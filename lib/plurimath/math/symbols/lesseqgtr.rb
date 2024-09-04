module Plurimath
  module Math
    module Symbols
      class Lesseqgtr < Symbol
        INPUT = {
          unicodemath: [["lesseqgtr", "&#x22da;"]],
          asciimath: [["&#x22da;"], parsing_wrapper(["lesseqgtr"], lang: :asciimath)],
          mathml: ["&#x22da;"],
          latex: [["lesseqgtr", "&#x22da;"]],
          omml: ["&#x22da;"],
          html: ["&#x22da;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lesseqgtr"
        end

        def to_asciimath(**)
          parsing_wrapper("lesseqgtr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22da;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22da;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22da;"
        end

        def to_html(**)
          "&#x22da;"
        end
      end
    end
  end
end
