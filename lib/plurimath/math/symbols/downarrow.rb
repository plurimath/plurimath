module Plurimath
  module Math
    module Symbols
      class Downarrow < Symbol
        INPUT = {
          unicodemath: [["Downarrow", "&#x21d3;"]],
          asciimath: [["&#x21d3;"], parsing_wrapper(["Downarrow"], lang: :asciimath)],
          mathml: ["&#x21d3;"],
          latex: [["Downarrow", "&#x21d3;"]],
          omml: ["&#x21d3;"],
          html: ["&#x21d3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Downarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("Downarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21d3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21d3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21d3;"
        end

        def to_html(**)
          "&#x21d3;"
        end
      end
    end
  end
end
