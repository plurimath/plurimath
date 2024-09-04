module Plurimath
  module Math
    module Symbols
      class Eta < Symbol
        INPUT = {
          unicodemath: [["eta", "&#x3b7;"], parsing_wrapper(["upeta"], lang: :unicode)],
          asciimath: [["eta", "&#x3b7;"], parsing_wrapper(["upeta"], lang: :asciimath)],
          mathml: ["&#x3b7;"],
          latex: [["upeta", "eta", "&#x3b7;"]],
          omml: ["&#x3b7;"],
          html: ["&#x3b7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\eta"
        end

        def to_asciimath(**)
          "eta"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3b7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3b7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3b7;"
        end

        def to_html(**)
          "&#x3b7;"
        end
      end
    end
  end
end
