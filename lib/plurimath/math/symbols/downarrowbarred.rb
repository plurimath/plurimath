module Plurimath
  module Math
    module Symbols
      class Downarrowbarred < Symbol
        INPUT = {
          unicodemath: [["&#x2908;"], parsing_wrapper(["downarrowbarred"], lang: :unicode)],
          asciimath: [["&#x2908;"], parsing_wrapper(["downarrowbarred"], lang: :asciimath)],
          mathml: ["&#x2908;"],
          latex: [["downarrowbarred", "&#x2908;"]],
          omml: ["&#x2908;"],
          html: ["&#x2908;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\downarrowbarred"
        end

        def to_asciimath(**)
          parsing_wrapper("downarrowbarred", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2908;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2908;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2908;"
        end

        def to_html(**)
          "&#x2908;"
        end
      end
    end
  end
end
