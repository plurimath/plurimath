module Plurimath
  module Math
    module Symbols
      class Smt < Symbol
        INPUT = {
          unicodemath: [["&#x2aaa;"], parsing_wrapper(["smt"], lang: :unicode)],
          asciimath: [["&#x2aaa;"], parsing_wrapper(["smt"], lang: :asciimath)],
          mathml: ["&#x2aaa;"],
          latex: [["smt", "&#x2aaa;"]],
          omml: ["&#x2aaa;"],
          html: ["&#x2aaa;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\smt"
        end

        def to_asciimath(**)
          parsing_wrapper("smt", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2aaa;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2aaa;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2aaa;"
        end

        def to_html(**)
          "&#x2aaa;"
        end
      end
    end
  end
end
