module Plurimath
  module Math
    module Symbols
      class Simge < Symbol
        INPUT = {
          unicodemath: [["&#x2aa0;"], parsing_wrapper(["simgE"], lang: :unicode)],
          asciimath: [["&#x2aa0;"], parsing_wrapper(["simgE"], lang: :asciimath)],
          mathml: ["&#x2aa0;"],
          latex: [["simgE", "&#x2aa0;"]],
          omml: ["&#x2aa0;"],
          html: ["&#x2aa0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\simgE"
        end

        def to_asciimath(**)
          parsing_wrapper("simgE", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2aa0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2aa0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2aa0;"
        end

        def to_html(**)
          "&#x2aa0;"
        end
      end
    end
  end
end
