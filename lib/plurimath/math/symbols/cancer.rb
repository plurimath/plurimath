module Plurimath
  module Math
    module Symbols
      class Cancer < Symbol
        INPUT = {
          unicodemath: [["&#x264b;"], parsing_wrapper(["cancer"])],
          asciimath: [["&#x264b;"], parsing_wrapper(["cancer"])],
          mathml: ["&#x264b;"],
          latex: [["cancer", "&#x264b;"]],
          omml: ["&#x264b;"],
          html: ["&#x264b;"],
        }.freeze

        # output methods
        def to_latex
          "\\cancer"
        end

        def to_asciimath
          parsing_wrapper("cancer")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x264b;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x264b;"
        end

        def to_omml_without_math_tag(_)
          "&#x264b;"
        end

        def to_html
          "&#x264b;"
        end
      end
    end
  end
end
