module Plurimath
  module Math
    module Symbols
      class Eqdot < Symbol
        INPUT = {
          unicodemath: [["&#x2a66;"], parsing_wrapper(["eqdot"], lang: :unicode)],
          asciimath: [["&#x2a66;"], parsing_wrapper(["eqdot"], lang: :asciimath)],
          mathml: ["&#x2a66;"],
          latex: [["eqdot", "&#x2a66;"]],
          omml: ["&#x2a66;"],
          html: ["&#x2a66;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\eqdot"
        end

        def to_asciimath(**)
          parsing_wrapper("eqdot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a66;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a66;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a66;"
        end

        def to_html(**)
          "&#x2a66;"
        end
      end
    end
  end
end
