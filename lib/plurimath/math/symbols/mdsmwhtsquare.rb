module Plurimath
  module Math
    module Symbols
      class Mdsmwhtsquare < Symbol
        INPUT = {
          unicodemath: [["&#x25fd;"], parsing_wrapper(["mdsmwhtsquare"], lang: :unicode)],
          asciimath: [["&#x25fd;"], parsing_wrapper(["mdsmwhtsquare"], lang: :asciimath)],
          mathml: ["&#x25fd;"],
          latex: [["mdsmwhtsquare", "&#x25fd;"]],
          omml: ["&#x25fd;"],
          html: ["&#x25fd;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mdsmwhtsquare"
        end

        def to_asciimath(**)
          parsing_wrapper("mdsmwhtsquare", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25fd;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25fd;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25fd;"
        end

        def to_html(**)
          "&#x25fd;"
        end
      end
    end
  end
end
