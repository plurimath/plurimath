module Plurimath
  module Math
    module Symbols
      class Nsucc < Symbol
        INPUT = {
          unicodemath: [["nsucc", "&#x2281;"]],
          asciimath: [["&#x2281;"], parsing_wrapper(["nsucc"], lang: :asciimath)],
          mathml: ["&#x2281;"],
          latex: [["nsucc", "&#x2281;"]],
          omml: ["&#x2281;"],
          html: ["&#x2281;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nsucc"
        end

        def to_asciimath(**)
          parsing_wrapper("nsucc", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2281;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2281;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2281;"
        end

        def to_html(**)
          "&#x2281;"
        end
      end
    end
  end
end
