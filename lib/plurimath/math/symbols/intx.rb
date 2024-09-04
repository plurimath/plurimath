module Plurimath
  module Math
    module Symbols
      class Intx < Symbol
        INPUT = {
          unicodemath: [["&#x2a18;"], parsing_wrapper(["intx"], lang: :unicode)],
          asciimath: [["&#x2a18;"], parsing_wrapper(["intx"], lang: :asciimath)],
          mathml: ["&#x2a18;"],
          latex: [["intx", "&#x2a18;"]],
          omml: ["&#x2a18;"],
          html: ["&#x2a18;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\intx"
        end

        def to_asciimath(**)
          parsing_wrapper("intx", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a18;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a18;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a18;"
        end

        def to_html(**)
          "&#x2a18;"
        end
      end
    end
  end
end
