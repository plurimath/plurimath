module Plurimath
  module Math
    module Symbols
      class Gnsim < Symbol
        INPUT = {
          unicodemath: [["&#x22e7;"], parsing_wrapper(["gnsim"], lang: :unicode)],
          asciimath: [["&#x22e7;"], parsing_wrapper(["gnsim"], lang: :asciimath)],
          mathml: ["&#x22e7;"],
          latex: [["gnsim", "&#x22e7;"]],
          omml: ["&#x22e7;"],
          html: ["&#x22e7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gnsim"
        end

        def to_asciimath(**)
          parsing_wrapper("gnsim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22e7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22e7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22e7;"
        end

        def to_html(**)
          "&#x22e7;"
        end
      end
    end
  end
end
