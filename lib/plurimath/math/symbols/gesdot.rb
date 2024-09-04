module Plurimath
  module Math
    module Symbols
      class Gesdot < Symbol
        INPUT = {
          unicodemath: [["&#x2a80;"], parsing_wrapper(["gesdot"], lang: :unicode)],
          asciimath: [["&#x2a80;"], parsing_wrapper(["gesdot"], lang: :asciimath)],
          mathml: ["&#x2a80;"],
          latex: [["gesdot", "&#x2a80;"]],
          omml: ["&#x2a80;"],
          html: ["&#x2a80;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gesdot"
        end

        def to_asciimath(**)
          parsing_wrapper("gesdot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a80;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a80;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a80;"
        end

        def to_html(**)
          "&#x2a80;"
        end
      end
    end
  end
end
