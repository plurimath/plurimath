module Plurimath
  module Math
    module Symbols
      class Nwsearrow < Symbol
        INPUT = {
          unicodemath: [["&#x2921;"], parsing_wrapper(["nwsearrow"])],
          asciimath: [["&#x2921;"], parsing_wrapper(["nwsearrow"])],
          mathml: ["&#x2921;"],
          latex: [["nwsearrow", "&#x2921;"]],
          omml: ["&#x2921;"],
          html: ["&#x2921;"],
        }.freeze

        # output methods
        def to_latex
          "\\nwsearrow"
        end

        def to_asciimath
          parsing_wrapper("nwsearrow")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2921;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2921;"
        end

        def to_omml_without_math_tag(_)
          "&#x2921;"
        end

        def to_html
          "&#x2921;"
        end
      end
    end
  end
end
