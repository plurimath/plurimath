module Plurimath
  module Math
    module Symbols
      class Mlcp < Symbol
        INPUT = {
          unicodemath: [["&#x2adb;"], parsing_wrapper(["mlcp"], lang: :unicode)],
          asciimath: [["&#x2adb;"], parsing_wrapper(["mlcp"], lang: :asciimath)],
          mathml: ["&#x2adb;"],
          latex: [["mlcp", "&#x2adb;"]],
          omml: ["&#x2adb;"],
          html: ["&#x2adb;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mlcp"
        end

        def to_asciimath(**)
          parsing_wrapper("mlcp", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2adb;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2adb;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2adb;"
        end

        def to_html(**)
          "&#x2adb;"
        end
      end
    end
  end
end
