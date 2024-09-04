module Plurimath
  module Math
    module Symbols
      class Rightleftharpoonsup < Symbol
        INPUT = {
          unicodemath: [["&#x2968;"], parsing_wrapper(["rightleftharpoonsup"], lang: :unicode)],
          asciimath: [["&#x2968;"], parsing_wrapper(["rightleftharpoonsup"], lang: :asciimath)],
          mathml: ["&#x2968;"],
          latex: [["rightleftharpoonsup", "&#x2968;"]],
          omml: ["&#x2968;"],
          html: ["&#x2968;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightleftharpoonsup"
        end

        def to_asciimath(**)
          parsing_wrapper("rightleftharpoonsup", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2968;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2968;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2968;"
        end

        def to_html(**)
          "&#x2968;"
        end
      end
    end
  end
end
