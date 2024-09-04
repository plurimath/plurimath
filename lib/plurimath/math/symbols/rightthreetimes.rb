module Plurimath
  module Math
    module Symbols
      class Rightthreetimes < Symbol
        INPUT = {
          unicodemath: [["rightthreetimes", "&#x22cc;"]],
          asciimath: [["&#x22cc;"], parsing_wrapper(["rightthreetimes"], lang: :asciimath)],
          mathml: ["&#x22cc;"],
          latex: [["rightthreetimes", "&#x22cc;"]],
          omml: ["&#x22cc;"],
          html: ["&#x22cc;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightthreetimes"
        end

        def to_asciimath(**)
          parsing_wrapper("rightthreetimes", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22cc;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22cc;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22cc;"
        end

        def to_html(**)
          "&#x22cc;"
        end
      end
    end
  end
end
