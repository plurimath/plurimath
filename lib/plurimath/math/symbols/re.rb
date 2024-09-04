module Plurimath
  module Math
    module Symbols
      class Re < Symbol
        INPUT = {
          unicodemath: [["Re", "&#x211c;"]],
          asciimath: [["&#x211c;"], parsing_wrapper(["Re"], lang: :asciimath)],
          mathml: ["&#x211c;"],
          latex: [["Re", "&#x211c;"]],
          omml: ["&#x211c;"],
          html: ["&#x211c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Re"
        end

        def to_asciimath(**)
          parsing_wrapper("Re", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x211c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x211c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x211c;"
        end

        def to_html(**)
          "&#x211c;"
        end
      end
    end
  end
end
