module Plurimath
  module Math
    module Symbols
      class Angles < Symbol
        INPUT = {
          unicodemath: [["&#x299e;"], parsing_wrapper(["angles"], lang: :unicode)],
          asciimath: [["&#x299e;"], parsing_wrapper(["angles"], lang: :asciimath)],
          mathml: ["&#x299e;"],
          latex: [["angles", "&#x299e;"]],
          omml: ["&#x299e;"],
          html: ["&#x299e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\angles"
        end

        def to_asciimath(**)
          parsing_wrapper("angles", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x299e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x299e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x299e;"
        end

        def to_html(**)
          "&#x299e;"
        end
      end
    end
  end
end
