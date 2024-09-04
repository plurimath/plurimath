module Plurimath
  module Math
    module Symbols
      class Gemini < Symbol
        INPUT = {
          unicodemath: [["&#x264a;"], parsing_wrapper(["gemini", "Gemini"], lang: :unicode)],
          asciimath: [["&#x264a;"], parsing_wrapper(["gemini", "Gemini"], lang: :asciimath)],
          mathml: ["&#x264a;"],
          latex: [["gemini", "Gemini", "&#x264a;"]],
          omml: ["&#x264a;"],
          html: ["&#x264a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gemini"
        end

        def to_asciimath(**)
          parsing_wrapper("Gemini", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x264a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x264a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x264a;"
        end

        def to_html(**)
          "&#x264a;"
        end
      end
    end
  end
end
