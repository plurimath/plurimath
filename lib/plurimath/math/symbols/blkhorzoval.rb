module Plurimath
  module Math
    module Symbols
      class Blkhorzoval < Symbol
        INPUT = {
          unicodemath: [["&#x2b2c;"], parsing_wrapper(["blkhorzoval"], lang: :unicode)],
          asciimath: [["&#x2b2c;"], parsing_wrapper(["blkhorzoval"], lang: :asciimath)],
          mathml: ["&#x2b2c;"],
          latex: [["blkhorzoval", "&#x2b2c;"]],
          omml: ["&#x2b2c;"],
          html: ["&#x2b2c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blkhorzoval"
        end

        def to_asciimath(**)
          parsing_wrapper("blkhorzoval", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b2c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b2c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b2c;"
        end

        def to_html
          "&#x2b2c;"
        end
      end
    end
  end
end
