module Plurimath
  module Math
    module Symbols
      class Rightrightarrows < Symbol
        INPUT = {
          unicodemath: [["rightrightarrows", "&#x21c9;"]],
          asciimath: [["&#x21c9;"], parsing_wrapper(["rightrightarrows"], lang: :asciimath)],
          mathml: ["&#x21c9;"],
          latex: [["rightrightarrows", "&#x21c9;"]],
          omml: ["&#x21c9;"],
          html: ["&#x21c9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightrightarrows"
        end

        def to_asciimath(**)
          parsing_wrapper("rightrightarrows", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21c9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21c9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21c9;"
        end

        def to_html(**)
          "&#x21c9;"
        end
      end
    end
  end
end
