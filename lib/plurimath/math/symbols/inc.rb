module Plurimath
  module Math
    module Symbols
      class Inc < Symbol
        INPUT = {
          unicodemath: [["inc", "&#x2206;"], parsing_wrapper(["increment"], lang: :unicode)],
          asciimath: [["&#x2206;"], parsing_wrapper(["inc", "increment"], lang: :asciimath)],
          mathml: ["&#x2206;"],
          latex: [["increment", "&#x2206;"], parsing_wrapper(["inc"], lang: :latex)],
          omml: ["&#x2206;"],
          html: ["&#x2206;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\increment"
        end

        def to_asciimath(**)
          parsing_wrapper("inc", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2206;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2206;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2206;"
        end

        def to_html(**)
          "&#x2206;"
        end
      end
    end
  end
end
