module Plurimath
  module Math
    module Symbols
      class Backsim < Symbol
        INPUT = {
          unicodemath: [["backsim", "&#x223d;"]],
          asciimath: [["&#x223d;"], parsing_wrapper(["backsim"], lang: :asciimath)],
          mathml: ["&#x223d;"],
          latex: [["backsim", "&#x223d;"]],
          omml: ["&#x223d;"],
          html: ["&#x223d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\backsim"
        end

        def to_asciimath(**)
          parsing_wrapper("backsim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x223d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x223d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x223d;"
        end

        def to_html(**)
          "&#x223d;"
        end
      end
    end
  end
end
