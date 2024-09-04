module Plurimath
  module Math
    module Symbols
      class Isine < Symbol
        INPUT = {
          unicodemath: [["&#x22f9;"], parsing_wrapper(["isinE"], lang: :unicode)],
          asciimath: [["&#x22f9;"], parsing_wrapper(["isinE"], lang: :asciimath)],
          mathml: ["&#x22f9;"],
          latex: [["isinE", "&#x22f9;"]],
          omml: ["&#x22f9;"],
          html: ["&#x22f9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\isinE"
        end

        def to_asciimath(**)
          parsing_wrapper("isinE", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22f9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22f9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22f9;"
        end

        def to_html(**)
          "&#x22f9;"
        end
      end
    end
  end
end
