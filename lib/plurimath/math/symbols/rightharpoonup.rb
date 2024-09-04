module Plurimath
  module Math
    module Symbols
      class Rightharpoonup < Symbol
        INPUT = {
          unicodemath: [["rightharpoonup", "&#x21c0;"]],
          asciimath: [["&#x21c0;"], parsing_wrapper(["rightharpoonup"], lang: :asciimath)],
          mathml: ["&#x21c0;"],
          latex: [["rightharpoonup", "&#x21c0;"]],
          omml: ["&#x21c0;"],
          html: ["&#x21c0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightharpoonup"
        end

        def to_asciimath(**)
          parsing_wrapper("rightharpoonup", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21c0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21c0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21c0;"
        end

        def to_html(**)
          "&#x21c0;"
        end
      end
    end
  end
end
