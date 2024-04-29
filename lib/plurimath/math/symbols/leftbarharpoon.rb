module Plurimath
  module Math
    module Symbols
      class Leftbarharpoon < Symbol
        INPUT = {
          unicodemath: [["&#x296a;"], parsing_wrapper(["leftharpoonupdash", "leftbarharpoon"])],
          asciimath: [["&#x296a;"], parsing_wrapper(["leftharpoonupdash", "leftbarharpoon"])],
          mathml: ["&#x296a;"],
          latex: [["leftharpoonupdash", "leftbarharpoon", "&#x296a;"]],
          omml: ["&#x296a;"],
          html: ["&#x296a;"],
        }.freeze

        # output methods
        def to_latex
          "\\leftharpoonupdash"
        end

        def to_asciimath
          parsing_wrapper("leftbarharpoon")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x296a;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x296a;"
        end

        def to_omml_without_math_tag(_)
          "&#x296a;"
        end

        def to_html
          "&#x296a;"
        end
      end
    end
  end
end
