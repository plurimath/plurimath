module Plurimath
  module Math
    module Symbols
      class Fracslash < Symbol
        INPUT = {
          unicodemath: [["&#x2044;"], parsing_wrapper(["fracslash"], lang: :unicode)],
          asciimath: [["&#x2044;"], parsing_wrapper(["fracslash"], lang: :asciimath)],
          mathml: ["&#x2044;"],
          latex: [["fracslash", "&#x2044;"]],
          omml: ["&#x2044;"],
          html: ["&#x2044;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\fracslash"
        end

        def to_asciimath(**)
          parsing_wrapper("fracslash", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2044;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2044;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2044;"
        end

        def to_html(**)
          "&#x2044;"
        end
      end
    end
  end
end
