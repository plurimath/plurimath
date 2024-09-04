module Plurimath
  module Math
    module Symbols
      class Blackhourglass < Symbol
        INPUT = {
          unicodemath: [["&#x29d7;"], parsing_wrapper(["blackhourglass"], lang: :unicode)],
          asciimath: [["&#x29d7;"], parsing_wrapper(["blackhourglass"], lang: :asciimath)],
          mathml: ["&#x29d7;"],
          latex: [["blackhourglass", "&#x29d7;"]],
          omml: ["&#x29d7;"],
          html: ["&#x29d7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blackhourglass"
        end

        def to_asciimath(**)
          parsing_wrapper("blackhourglass", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29d7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29d7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29d7;"
        end

        def to_html(**)
          "&#x29d7;"
        end
      end
    end
  end
end
