module Plurimath
  module Math
    module Symbols
      class Utilde < Symbol
        INPUT = {
          unicodemath: [["&#x330;"], parsing_wrapper(["wideutilde", "utilde"], lang: :unicode)],
          asciimath: [["&#x330;"], parsing_wrapper(["wideutilde", "utilde"], lang: :asciimath)],
          mathml: ["&#x330;"],
          latex: [["wideutilde", "utilde", "&#x330;"]],
          omml: ["&#x330;"],
          html: ["&#x330;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\wideutilde"
        end

        def to_asciimath(**)
          parsing_wrapper("utilde", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x330;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x330;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x330;"
        end

        def to_html(**)
          "&#x330;"
        end
      end
    end
  end
end
