module Plurimath
  module Math
    module Symbols
      class Gneqq < Symbol
        INPUT = {
          unicodemath: [["gneqq", "&#x2269;"]],
          asciimath: [["&#x2269;"], parsing_wrapper(["gneqq"], lang: :asciimath)],
          mathml: ["&#x2269;"],
          latex: [["gneqq", "&#x2269;"]],
          omml: ["&#x2269;"],
          html: ["&#x2269;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gneqq"
        end

        def to_asciimath(**)
          parsing_wrapper("gneqq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2269;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2269;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2269;"
        end

        def to_html(**)
          "&#x2269;"
        end
      end
    end
  end
end
