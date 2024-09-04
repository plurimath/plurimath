module Plurimath
  module Math
    module Symbols
      class Rightharpoondown < Symbol
        INPUT = {
          unicodemath: [["rightharpoondown", "&#x21c1;"]],
          asciimath: [["&#x21c1;"], parsing_wrapper(["rightharpoondown"], lang: :asciimath)],
          mathml: ["&#x21c1;"],
          latex: [["rightharpoondown", "&#x21c1;"]],
          omml: ["&#x21c1;"],
          html: ["&#x21c1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightharpoondown"
        end

        def to_asciimath(**)
          parsing_wrapper("rightharpoondown", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21c1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21c1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21c1;"
        end

        def to_html(**)
          "&#x21c1;"
        end
      end
    end
  end
end
