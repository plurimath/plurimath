# frozen_string_literal: true

module Plurimath
  class Mathml
    module Models
      PASSTHROUGH_MODELS = {
        maligngroup: "Maligngroup",
        malignmark: "Malignmark",
        maction: "Maction",
        mscarry: "Mscarry",
        mprescripts: "Mprescripts",
        a: "A",
      }.freeze

      module_function

      def register
        @register ||= begin
          reg = Lutaml::Model::Register.new(:plurimath, fallback: [:mml_v4, :mml_v3])
          Lutaml::Model::GlobalRegister.register(reg)
          register_passthrough_models(reg)
          reg
        end
      end

      def register_model(klass, id:)
        register.register_model(klass, id: id)
      end

      def register_passthrough_models(reg)
        PASSTHROUGH_MODELS.each do |id, class_name|
          klass = Mml::V4.const_get(class_name)
          reg.register_model(klass, id: id)
        end
      end
    end
  end
end
