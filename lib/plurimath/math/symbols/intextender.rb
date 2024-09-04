module Plurimath
  module Math
    module Symbols
      class Intextender < Symbol
        INPUT = {
          unicodemath: [["&#x23ae;"], parsing_wrapper(["intextender"], lang: :unicode)],
          asciimath: [["&#x23ae;"], parsing_wrapper(["intextender"], lang: :asciimath)],
          mathml: ["&#x23ae;"],
          latex: [["intextender", "&#x23ae;"]],
          omml: ["&#x23ae;"],
          html: ["&#x23ae;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\intextender"
        end

        def to_asciimath(**)
          parsing_wrapper("intextender", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23ae;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23ae;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23ae;"
        end

        def to_html(**)
          "&#x23ae;"
        end
      end
    end
  end
end
