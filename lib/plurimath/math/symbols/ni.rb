module Plurimath
  module Math
    module Symbols
      class Ni < Symbol
        INPUT = {
          unicodemath: [["ni", "&#x220b;"], parsing_wrapper(["owns"], lang: :unicode)],
          asciimath: [["&#x220b;"], parsing_wrapper(["ni", "owns"], lang: :asciimath)],
          mathml: ["&#x220b;"],
          latex: [["owns", "ni", "&#x220b;"]],
          omml: ["&#x220b;"],
          html: ["&#x220b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\owns"
        end

        def to_asciimath(**)
          parsing_wrapper("ni", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x220b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x220b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x220b;"
        end

        def to_html(**)
          "&#x220b;"
        end
      end
    end
  end
end
