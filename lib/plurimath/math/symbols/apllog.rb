module Plurimath
  module Math
    module Symbols
      class Apllog < Symbol
        INPUT = {
          unicodemath: [["&#x235f;"], parsing_wrapper(["APLlog"], lang: :unicode)],
          asciimath: [["&#x235f;"], parsing_wrapper(["APLlog"], lang: :asciimath)],
          mathml: ["&#x235f;"],
          latex: [["APLlog", "&#x235f;"]],
          omml: ["&#x235f;"],
          html: ["&#x235f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\APLlog"
        end

        def to_asciimath(**)
          parsing_wrapper("APLlog", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x235f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x235f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x235f;"
        end

        def to_html(**)
          "&#x235f;"
        end
      end
    end
  end
end
