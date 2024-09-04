module Plurimath
  module Math
    module Symbols
      class Bot < Symbol
        INPUT = {
          unicodemath: [["&#x2aeb;"], parsing_wrapper(["Vbar", "Perp", "Bot"], lang: :unicode)],
          asciimath: [["&#x2aeb;"], parsing_wrapper(["Vbar", "Perp", "Bot"], lang: :asciimath)],
          mathml: ["&#x2aeb;"],
          latex: [["Vbar", "Perp", "Bot", "&#x2aeb;"]],
          omml: ["&#x2aeb;"],
          html: ["&#x2aeb;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Vbar"
        end

        def to_asciimath(**)
          parsing_wrapper("Bot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2aeb;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2aeb;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2aeb;"
        end

        def to_html(**)
          "&#x2aeb;"
        end
      end
    end
  end
end
