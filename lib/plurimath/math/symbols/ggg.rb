module Plurimath
  module Math
    module Symbols
      class Ggg < Symbol
        INPUT = {
          unicodemath: [["ggg", "&#x22d9;"]],
          asciimath: [["&#x22d9;"], parsing_wrapper(["ggg"], lang: :asciimath)],
          mathml: ["&#x22d9;"],
          latex: [["ggg", "&#x22d9;"]],
          omml: ["&#x22d9;"],
          html: ["&#x22d9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ggg"
        end

        def to_asciimath(**)
          parsing_wrapper("ggg", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22d9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22d9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22d9;"
        end

        def to_html(**)
          "&#x22d9;"
        end
      end
    end
  end
end
