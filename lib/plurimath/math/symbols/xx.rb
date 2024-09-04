module Plurimath
  module Math
    module Symbols
      class Xx < Symbol
        INPUT = {
          unicodemath: [["times", "&#xd7;"], parsing_wrapper(["xx"], lang: :unicode)],
          asciimath: [["times", "xx", "&#xd7;"]],
          mathml: ["&#xd7;"],
          latex: [["times", "&#xd7;"], parsing_wrapper(["xx"], lang: :latex)],
          omml: ["&#xd7;"],
          html: ["&#xd7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\times"
        end

        def to_asciimath(**)
          "times"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#xd7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#xd7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#xd7;"
        end

        def to_html(**)
          "&#xd7;"
        end
      end
    end
  end
end
