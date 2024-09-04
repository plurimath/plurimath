module Plurimath
  module Math
    module Symbols
      class Lnsim < Symbol
        INPUT = {
          unicodemath: [["lnsim", "&#x22e6;"]],
          asciimath: [["&#x22e6;"], parsing_wrapper(["lnsim"], lang: :asciimath)],
          mathml: ["&#x22e6;"],
          latex: [["lnsim", "&#x22e6;"]],
          omml: ["&#x22e6;"],
          html: ["&#x22e6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lnsim"
        end

        def to_asciimath(**)
          parsing_wrapper("lnsim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22e6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22e6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22e6;"
        end

        def to_html(**)
          "&#x22e6;"
        end
      end
    end
  end
end
