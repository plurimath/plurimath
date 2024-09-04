module Plurimath
  module Math
    module Symbols
      class Sub < Symbol
        INPUT = {
          unicodemath: [["subset", "&#x2282;"], parsing_wrapper(["sub"], lang: :unicode)],
          asciimath: [["subset", "sub", "&#x2282;"]],
          mathml: ["&#x2282;"],
          latex: [["subset", "&#x2282;"], parsing_wrapper(["sub"], lang: :latex)],
          omml: ["&#x2282;"],
          html: ["&#x2282;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\subset"
        end

        def to_asciimath(**)
          "subset"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2282;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2282;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2282;"
        end

        def to_html(**)
          "&#x2282;"
        end
      end
    end
  end
end
