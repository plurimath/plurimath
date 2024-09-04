module Plurimath
  module Math
    module Symbols
      class Simgtr < Symbol
        INPUT = {
          unicodemath: [["&#x2a9e;"], parsing_wrapper(["simgtr"], lang: :unicode)],
          asciimath: [["&#x2a9e;"], parsing_wrapper(["simgtr"], lang: :asciimath)],
          mathml: ["&#x2a9e;"],
          latex: [["simgtr", "&#x2a9e;"]],
          omml: ["&#x2a9e;"],
          html: ["&#x2a9e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\simgtr"
        end

        def to_asciimath(**)
          parsing_wrapper("simgtr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a9e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a9e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a9e;"
        end

        def to_html(**)
          "&#x2a9e;"
        end
      end
    end
  end
end
