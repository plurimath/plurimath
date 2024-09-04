module Plurimath
  module Math
    module Symbols
      class Doublebarwedge < Symbol
        INPUT = {
          unicodemath: [["&#x2a5e;"], parsing_wrapper(["doublebarwedge"], lang: :unicode)],
          asciimath: [["&#x2a5e;"], parsing_wrapper(["doublebarwedge"], lang: :asciimath)],
          mathml: ["&#x2a5e;"],
          latex: [["doublebarwedge", "&#x2a5e;"]],
          omml: ["&#x2a5e;"],
          html: ["&#x2a5e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\doublebarwedge"
        end

        def to_asciimath(**)
          parsing_wrapper("doublebarwedge", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a5e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a5e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a5e;"
        end

        def to_html(**)
          "&#x2a5e;"
        end
      end
    end
  end
end
