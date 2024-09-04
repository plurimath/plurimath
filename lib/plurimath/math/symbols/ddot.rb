module Plurimath
  module Math
    module Symbols
      class Ddot < Symbol
        INPUT = {
          unicodemath: [["&#x308;", ".."]],
          asciimath: [["&#x308;", ".."]],
          mathml: ["&#x308;", ".."],
          latex: [["&#x308;", ".."]],
          omml: ["&#x308;", ".."],
          html: ["&#x308;", ".."],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ddot"
        end

        def to_asciimath(**)
          "ddot"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x308;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x308;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x308;"
        end

        def to_html(**)
          "&#x308;"
        end
      end
    end
  end
end
