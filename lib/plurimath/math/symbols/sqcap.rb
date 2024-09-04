module Plurimath
  module Math
    module Symbols
      class Sqcap < Symbol
        INPUT = {
          unicodemath: [["&#x2a4e;"], parsing_wrapper(["Sqcap"], lang: :unicode)],
          asciimath: [["&#x2a4e;"], parsing_wrapper(["Sqcap"], lang: :asciimath)],
          mathml: ["&#x2a4e;"],
          latex: [["Sqcap", "&#x2a4e;"]],
          omml: ["&#x2a4e;"],
          html: ["&#x2a4e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Sqcap"
        end

        def to_asciimath(**)
          parsing_wrapper("Sqcap", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a4e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a4e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a4e;"
        end

        def to_html(**)
          "&#x2a4e;"
        end
      end
    end
  end
end
