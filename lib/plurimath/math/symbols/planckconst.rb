module Plurimath
  module Math
    module Symbols
      class Planckconst < Symbol
        INPUT = {
          unicodemath: [["&#x210e;"], parsing_wrapper(["Planckconst"], lang: :unicode)],
          asciimath: [["&#x210e;"], parsing_wrapper(["Planckconst"], lang: :asciimath)],
          mathml: ["&#x210e;"],
          latex: [["Planckconst", "&#x210e;"]],
          omml: ["&#x210e;"],
          html: ["&#x210e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Planckconst"
        end

        def to_asciimath(**)
          parsing_wrapper("Planckconst", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x210e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x210e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x210e;"
        end

        def to_html(**)
          "&#x210e;"
        end
      end
    end
  end
end
