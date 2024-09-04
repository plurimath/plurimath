module Plurimath
  module Math
    module Symbols
      class Bigslopedvee < Symbol
        INPUT = {
          unicodemath: [["&#x2a57;"], parsing_wrapper(["bigslopedvee"], lang: :unicode)],
          asciimath: [["&#x2a57;"], parsing_wrapper(["bigslopedvee"], lang: :asciimath)],
          mathml: ["&#x2a57;"],
          latex: [["bigslopedvee", "&#x2a57;"]],
          omml: ["&#x2a57;"],
          html: ["&#x2a57;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigslopedvee"
        end

        def to_asciimath(**)
          parsing_wrapper("bigslopedvee", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a57;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a57;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a57;"
        end

        def to_html(**)
          "&#x2a57;"
        end
      end
    end
  end
end
