module Plurimath
  module Math
    module Symbols
      class Smashtimes < Symbol
        INPUT = {
          unicodemath: [["&#x2a33;"], parsing_wrapper(["smashtimes"], lang: :unicode)],
          asciimath: [["&#x2a33;"], parsing_wrapper(["smashtimes"], lang: :asciimath)],
          mathml: ["&#x2a33;"],
          latex: [["smashtimes", "&#x2a33;"]],
          omml: ["&#x2a33;"],
          html: ["&#x2a33;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\smashtimes"
        end

        def to_asciimath(**)
          parsing_wrapper("smashtimes", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a33;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a33;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a33;"
        end

        def to_html(**)
          "&#x2a33;"
        end
      end
    end
  end
end
