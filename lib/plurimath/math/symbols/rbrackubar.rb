module Plurimath
  module Math
    module Symbols
      class Rbrackubar < Symbol
        INPUT = {
          unicodemath: [["&#x298c;"], parsing_wrapper(["rbrackubar"], lang: :unicode)],
          asciimath: [["&#x298c;"], parsing_wrapper(["rbrackubar"], lang: :asciimath)],
          mathml: ["&#x298c;"],
          latex: [["rbrackubar", "&#x298c;"]],
          omml: ["&#x298c;"],
          html: ["&#x298c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rbrackubar"
        end

        def to_asciimath(**)
          parsing_wrapper("rbrackubar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x298c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x298c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x298c;"
        end

        def to_html(**)
          "&#x298c;"
        end
      end
    end
  end
end
