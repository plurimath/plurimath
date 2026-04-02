# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      module_function

      def register
        @register ||= begin
          reg = Lutaml::Model::Register.new(:plurimath, fallback: [:mml_v4, :mml_v3])
          Lutaml::Model::GlobalRegister.register(reg)
          reg
        end
      end

      def register_model(klass, id:)
        register.register_model(klass, id: id)
      end
    end
  end
end
