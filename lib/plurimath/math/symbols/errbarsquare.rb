module Plurimath
  module Math
    module Symbols
      class Errbarsquare < Symbol
        INPUT = {
          unicodemath: [["&#x29ee;"], parsing_wrapper(["errbarsquare"])],
          asciimath: [["&#x29ee;"], parsing_wrapper(["errbarsquare"])],
          mathml: ["&#x29ee;"],
          latex: [["errbarsquare", "&#x29ee;"]],
          omml: ["&#x29ee;"],
          html: ["&#x29ee;"],
        }.freeze

        # output methods
        def to_latex
          "\\errbarsquare"
        end

        def to_asciimath
          parsing_wrapper("errbarsquare")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29ee;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mi") << "&#x29ee;"
        end

        def to_omml_without_math_tag(_)
          "&#x29ee;"
        end

        def to_html
          "&#x29ee;"
        end
      end
    end
  end
end
