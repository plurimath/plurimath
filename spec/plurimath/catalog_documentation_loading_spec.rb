require "open3"
require "rbconfig"

RSpec.describe "Catalog documentation loading", if: RUBY_ENGINE != "opal", engine_loop: :once do
  %w[ox oga].each do |engine|
    it "preserves first-use inheritance and super calls with #{engine}" do
      code = <<~'RUBY'
        require "json"
        require "plurimath"
        class CatalogParent
          extend Plurimath::Documentation
          CATALOG_TYPE = :unary
          DESCRIPTION = "Parent description"
          REFERENCE = "https://example.com/parent"
          EXAMPLE = -> { expr(sym("x")) }
        end
        class CatalogChild < CatalogParent
          def self.catalog_name
            "custom-#{super}"
          end
        end
        class CatalogSymbol < Plurimath::Math::Symbols::Alpha
          def self.catalog_name
            "custom-#{super}"
          end
        end
        before = $LOADED_FEATURES.grep(%r{/catalog_methods\.rb$})
        names = [CatalogChild.catalog_name, CatalogSymbol.catalog_name]
        # Classes exist before the implementation is included. Repeated calls
        # and the parent must share the implementation without replacing overrides.
        puts JSON.generate(
          before: before, names: names,
          repeated: [CatalogChild.catalog_name, CatalogSymbol.catalog_name],
          inherited_type: CatalogChild.catalog_type,
          own_description: CatalogChild.description,
          parent_description: CatalogParent.description,
          example: CatalogParent.example_formula.to_asciimath,
          public_helpers: CatalogParent.respond_to?(:expr),
          private_helpers: CatalogParent.respond_to?(:expr, true),
          parameters: CatalogParent.method(:catalog_name).parameters,
          loaded: $LOADED_FEATURES.grep(%r{/catalog_methods\.rb$}).size
        )
      RUBY
      env = { "PLURIMATH_OGA" => engine == "oga" ? "1" : nil, "PLURIMATH_LEPTRIS" => nil }
      out, err, status = Open3.capture3(env, RbConfig.ruby, "-Ilib", "-e", code)
      expect(status.exitstatus).to eq(0), err
      report = JSON.parse(out)
      expect(report.fetch("before")).to be_empty
      expect(report.fetch("names")).to eq(%w[custom-catalogchild custom-catalogsymbol])
      expect(report.fetch("repeated")).to eq(report.fetch("names"))
      expect(report.fetch("inherited_type")).to eq("unary")
      expect(report.fetch("own_description")).to be_nil
      expect(report.fetch("parent_description")).to eq("Parent description")
      expect(report.fetch("example")).to eq("x")
      expect(report.fetch("public_helpers")).to be(false)
      expect(report.fetch("private_helpers")).to be(true)
      expect(report.fetch("parameters")).to eq([])
      expect(report.fetch("loaded")).to eq(2)
    end
  end
end
