module Plurimath
  module Math
    module Symbols
      class Bigcupdot < Symbol
        INPUT = {
          unicodemath: [["&#x2a03;"], parsing_wrapper(["bigcupdot"])],
          asciimath: [["&#x2a03;"], parsing_wrapper(["bigcupdot"])],
          mathml: ["&#x2a03;"],
          latex: [["bigcupdot", "&#x2a03;"]],
          omml: ["&#x2a03;"],
          html: ["&#x2a03;"],
        }.freeze

        # output methods
        def to_latex
          "\\bigcupdot"
        end

        def to_asciimath
          parsing_wrapper("bigcupdot")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a03;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2a03;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a03;"
        end

        def to_html
          "&#x2a03;"
        end
      end
    end
  end
end
