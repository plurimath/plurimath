module Plurimath
  module Math
    module Symbols
      class Measeq < Symbol
        INPUT = {
          unicodemath: [["&#x225e;"], parsing_wrapper(["measeq"], lang: :unicode)],
          asciimath: [["&#x225e;"], parsing_wrapper(["measeq"], lang: :asciimath)],
          mathml: ["&#x225e;"],
          latex: [["measeq", "&#x225e;"]],
          omml: ["&#x225e;"],
          html: ["&#x225e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\measeq"
        end

        def to_asciimath(**)
          parsing_wrapper("measeq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x225e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x225e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x225e;"
        end

        def to_html(**)
          "&#x225e;"
        end
      end
    end
  end
end
