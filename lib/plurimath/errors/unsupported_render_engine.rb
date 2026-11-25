# frozen_string_literal: true

module Plurimath
  module Errors
    class UnsupportedRenderEngine < Plurimath::Error
      def initialize(engine, known)
        @engine = engine
        @known = known.map(&:inspect).join(", ")
        super(message)
      end

      def message
        "[plurimath] Unsupported render engine #{@engine.inspect}. " \
          "Known engines are: #{@known}."
      end
    end
  end
end
