# frozen_string_literal: true

module Plurimath
  module Errors
    module Evaluation
      class Error < Plurimath::Error
        # Preserve the typed refusal and diagnostic as OpenMath error arguments.
        def to_openmath(version: 2)
          require "cgi"

          type = CGI.escapeHTML(self.class.name)
          diagnostic = CGI.escapeHTML(message)
          xml = %(<OMOBJ xmlns="http://www.openmath.org/OpenMath" version="#{version}.0"><OME><OMS cd="error" name="unexpected"/><OMSTR>#{type}</OMSTR><OMSTR>#{diagnostic}</OMSTR></OME></OMOBJ>)
          Plurimath::Openmath.new(xml, version: version).to_formula.to_openmath(version: version)
        end
      end
    end
  end
end
