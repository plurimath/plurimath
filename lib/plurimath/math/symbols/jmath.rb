module Plurimath
  module Math
    module Symbols
      class Jmath < Symbol
        INPUT = {
          unicodemath: [["jmath", "&#x237;"]],
          asciimath: [["&#x237;"], parsing_wrapper(["jmath"], lang: :asciimath)],
          mathml: ["&#x237;"],
          latex: [["jmath", "&#x237;"]],
          omml: ["&#x237;"],
          html: ["&#x237;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\jmath"
        end

        def to_asciimath(**)
          parsing_wrapper("jmath", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x237;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x237;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x237;"
        end

        def to_html(**)
          "&#x237;"
        end
      end
    end
  end
end
