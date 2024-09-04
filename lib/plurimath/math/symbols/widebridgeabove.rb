module Plurimath
  module Math
    module Symbols
      class Widebridgeabove < Symbol
        INPUT = {
          unicodemath: [["&#x20e9;"], parsing_wrapper(["widebridgeabove"], lang: :unicode)],
          asciimath: [["&#x20e9;"], parsing_wrapper(["widebridgeabove"], lang: :asciimath)],
          mathml: ["&#x20e9;"],
          latex: [["widebridgeabove", "&#x20e9;"]],
          omml: ["&#x20e9;"],
          html: ["&#x20e9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\widebridgeabove"
        end

        def to_asciimath(**)
          parsing_wrapper("widebridgeabove", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x20e9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x20e9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x20e9;"
        end

        def to_html(**)
          "&#x20e9;"
        end
      end
    end
  end
end
