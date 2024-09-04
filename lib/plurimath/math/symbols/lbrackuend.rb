module Plurimath
  module Math
    module Symbols
      class Lbrackuend < Symbol
        INPUT = {
          unicodemath: [["&#x23a1;"], parsing_wrapper(["lbrackuend"], lang: :unicode)],
          asciimath: [["&#x23a1;"], parsing_wrapper(["lbrackuend"], lang: :asciimath)],
          mathml: ["&#x23a1;"],
          latex: [["lbrackuend", "&#x23a1;"]],
          omml: ["&#x23a1;"],
          html: ["&#x23a1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lbrackuend"
        end

        def to_asciimath(**)
          parsing_wrapper("lbrackuend", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23a1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23a1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23a1;"
        end

        def to_html(**)
          "&#x23a1;"
        end
      end
    end
  end
end
