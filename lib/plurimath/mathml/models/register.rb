# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      extend Mml::ContextConfiguration

      CONTEXT_ID = :plurimath

      module_function

      def ensure_context!
        context || populate_context!
      end

      class << self
        private

        def base_type_context
          create_type_context(
            id: context_id,
            registry: Lutaml::Model::TypeRegistry.new,
            fallback_to: [:mml_v4],
          )
        end
      end
    end
  end
end
