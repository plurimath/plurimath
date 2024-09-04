module Plurimath
  module Math
    module Symbols
      class Blackcircledownarrow < Symbol
        INPUT = {
          unicodemath: [["&#x29ed;"], parsing_wrapper(["blackcircledownarrow"], lang: :unicode)],
          asciimath: [["&#x29ed;"], parsing_wrapper(["blackcircledownarrow"], lang: :asciimath)],
          mathml: ["&#x29ed;"],
          latex: [["blackcircledownarrow", "&#x29ed;"]],
          omml: ["&#x29ed;"],
          html: ["&#x29ed;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blackcircledownarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("blackcircledownarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29ed;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29ed;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29ed;"
        end

        def to_html(**)
          "&#x29ed;"
        end
      end
    end
  end
end
