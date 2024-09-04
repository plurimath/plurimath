module Plurimath
  module Math
    module Symbols
      class Cirmid < Symbol
        INPUT = {
          unicodemath: [["&#x2aef;"], parsing_wrapper(["cirmid"], lang: :unicode)],
          asciimath: [["&#x2aef;"], parsing_wrapper(["cirmid"], lang: :asciimath)],
          mathml: ["&#x2aef;"],
          latex: [["cirmid", "&#x2aef;"]],
          omml: ["&#x2aef;"],
          html: ["&#x2aef;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\cirmid"
        end

        def to_asciimath(**)
          parsing_wrapper("cirmid", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2aef;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2aef;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2aef;"
        end

        def to_html(**)
          "&#x2aef;"
        end
      end
    end
  end
end
