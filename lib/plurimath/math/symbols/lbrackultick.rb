module Plurimath
  module Math
    module Symbols
      class Lbrackultick < Symbol
        INPUT = {
          unicodemath: [["&#x298d;"], parsing_wrapper(["lbrackultick"], lang: :unicode)],
          asciimath: [["&#x298d;"], parsing_wrapper(["lbrackultick"], lang: :asciimath)],
          mathml: ["&#x298d;"],
          latex: [["lbrackultick", "&#x298d;"]],
          omml: ["&#x298d;"],
          html: ["&#x298d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lbrackultick"
        end

        def to_asciimath(**)
          parsing_wrapper("lbrackultick", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x298d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x298d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x298d;"
        end

        def to_html(**)
          "&#x298d;"
        end
      end
    end
  end
end
