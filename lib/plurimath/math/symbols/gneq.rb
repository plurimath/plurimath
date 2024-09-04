module Plurimath
  module Math
    module Symbols
      class Gneq < Symbol
        INPUT = {
          unicodemath: [["&#x2a88;"], parsing_wrapper(["gneq"], lang: :unicode)],
          asciimath: [["&#x2a88;"], parsing_wrapper(["gneq"], lang: :asciimath)],
          mathml: ["&#x2a88;"],
          latex: [["gneq", "&#x2a88;"]],
          omml: ["&#x2a88;"],
          html: ["&#x2a88;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gneq"
        end

        def to_asciimath(**)
          parsing_wrapper("gneq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a88;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a88;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a88;"
        end

        def to_html(**)
          "&#x2a88;"
        end
      end
    end
  end
end
