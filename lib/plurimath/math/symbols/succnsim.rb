module Plurimath
  module Math
    module Symbols
      class Succnsim < Symbol
        INPUT = {
          unicodemath: [["succnsim", "&#x22e9;"]],
          asciimath: [["&#x22e9;"], parsing_wrapper(["succnsim"], lang: :asciimath)],
          mathml: ["&#x22e9;"],
          latex: [["succnsim", "&#x22e9;"]],
          omml: ["&#x22e9;"],
          html: ["&#x22e9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\succnsim"
        end

        def to_asciimath(**)
          parsing_wrapper("succnsim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22e9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22e9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22e9;"
        end

        def to_html(**)
          "&#x22e9;"
        end
      end
    end
  end
end
