module Plurimath
  module Math
    module Symbols
      class Blocklefthalf < Symbol
        INPUT = {
          unicodemath: [["&#x258c;"], parsing_wrapper(["blocklefthalf"], lang: :unicode)],
          asciimath: [["&#x258c;"], parsing_wrapper(["blocklefthalf"], lang: :asciimath)],
          mathml: ["&#x258c;"],
          latex: [["blocklefthalf", "&#x258c;"]],
          omml: ["&#x258c;"],
          html: ["&#x258c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blocklefthalf"
        end

        def to_asciimath(**)
          parsing_wrapper("blocklefthalf", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x258c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x258c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x258c;"
        end

        def to_html(**)
          "&#x258c;"
        end
      end
    end
  end
end
