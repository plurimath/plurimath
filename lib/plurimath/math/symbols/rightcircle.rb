module Plurimath
  module Math
    module Symbols
      class Rightcircle < Symbol
        INPUT = {
          unicodemath: [["&#x25d7;"], parsing_wrapper(["blackrighthalfcircle", "RIGHTCIRCLE"], lang: :unicode)],
          asciimath: [["&#x25d7;"], parsing_wrapper(["blackrighthalfcircle", "RIGHTCIRCLE"], lang: :asciimath)],
          mathml: ["&#x25d7;"],
          latex: [["blackrighthalfcircle", "RIGHTCIRCLE", "&#x25d7;"]],
          omml: ["&#x25d7;"],
          html: ["&#x25d7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blackrighthalfcircle"
        end

        def to_asciimath(**)
          parsing_wrapper("RIGHTCIRCLE", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25d7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25d7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25d7;"
        end

        def to_html(**)
          "&#x25d7;"
        end
      end
    end
  end
end
