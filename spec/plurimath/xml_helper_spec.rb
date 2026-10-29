require "spec_helper"

# Characterization specs for the XML element builders extracted from
# Plurimath::Utility into Plurimath::XmlHelper (macro refactor). Known quirks
# remain pinned with "# quirk:" comments; behavior changes belong in a later,
# separate PR together with the production-code change.
#
# Every example runs twice (Ox and Oga, via the around hook in spec_helper).
# Assertions stick to engine-stable properties: node name, attribute values,
# children, and the string produced by Plurimath.xml_engine.dump(..., indent: 2),
# which is byte-identical across engines for these structures. The one genuinely
# engine-dependent surface (namespaced attribute hash keys / [] lookup keys) is
# asserted per-engine.
RSpec.describe Plurimath::XmlHelper do
  # Whitespace-collapsed engine dump; the raw dump (indent: 2) is identical
  # across Ox and Oga, collapsing makes the expectations single-line.
  def dumped(element)
    Plurimath.xml_engine.dump(element, indent: 2).gsub(/\n\s*/, "")
  end

  def oga_engine?
    Plurimath.xml_engine == Plurimath::XmlEngine::Oga
  end

  describe ".ox_element" do
    it "builds an element with the given name and no attributes or children" do
      element = described_class.ox_element("mi")
      expect(element.name).to eq("mi")
      expect(element.attributes).to eq({})
      expect(element.nodes).to eq([])
      expect(dumped(element)).to eq("<mi/>")
    end

    it "prefixes the name with the namespace" do
      element = described_class.ox_element("mo", namespace: "m")
      expect(element.name).to eq("m:mo")
      expect(dumped(element)).to eq("<m:mo/>")
    end

    it "sets plain attributes readable via #attributes and #[]" do
      element = described_class.ox_element(
        "mstyle", attributes: { mathvariant: "bold", displaystyle: "true" }
      )
      expect(element.attributes).to eq("mathvariant" => "bold", "displaystyle" => "true")
      expect(element["mathvariant"]).to eq("bold")
      expect(dumped(element)).to eq('<mstyle mathvariant="bold" displaystyle="true"/>')
    end

    it "serializes namespaced attributes identically on both engines" do
      element = described_class.ox_element(
        "naryPr", namespace: "m", attributes: { "m:val": "1" }
      )
      expect(dumped(element)).to eq('<m:naryPr m:val="1"/>')
      # engine-stable composite lookup: exactly one of the two keys hits
      expect(element["m:val"] || element["val"]).to eq("1")
    end

    # quirk: the in-memory attribute key for namespaced attributes is
    # engine-dependent — Ox keeps the "m:" prefix, Oga strips it (and its []
    # only answers to the stripped name). Serialization is identical.
    it "exposes namespaced attribute hash keys differently per engine" do
      element = described_class.ox_element(
        "naryPr", namespace: "m", attributes: { "m:val": "1" }
      )
      if oga_engine?
        expect(element.attributes).to eq("val" => "1")
        expect(element["val"]).to eq("1")
        expect(element["m:val"]).to be_nil
      else
        expect(element.attributes).to eq("m:val" => "1")
        expect(element["m:val"]).to eq("1")
        expect(element["val"]).to be_nil
      end
    end

    it "decodes HTML entities in attribute values to unicode" do
      element = described_class.ox_element(
        "chr", namespace: "m", attributes: { "m:val": "&#x2211;" }
      )
      expect(dumped(element)).to eq('<m:chr m:val="∑"/>')
      expect(element["m:val"] || element["val"]).to eq("∑")
    end

    it "accepts the default empty-array attributes" do
      element = described_class.ox_element("mrow", attributes: [])
      expect(element.attributes).to eq({})
      expect(dumped(element)).to eq("<mrow/>")
    end
  end

  describe ".update_nodes" do
    it "appends nodes in order and returns the same element" do
      row = described_class.ox_element("mrow")
      mi = described_class.ox_element("mi") << "x"
      mo = described_class.ox_element("mo") << "+"
      mn = described_class.ox_element("mn") << "1"

      result = described_class.update_nodes(row, [mi, mo, mn])
      expect(result).to be(row)
      expect(result.nodes.map(&:name)).to eq(%w[mi mo mn])
      expect(dumped(result)).to eq("<mrow><mi>x</mi><mo>+</mo><mn>1</mn></mrow>")
    end

    it "skips nils and flattens nested arrays recursively" do
      # mirrors Nary#omml_nary_tag, where omml_parameter entries can be nil
      # and nested arrays of elements
      row = described_class.ox_element("mrow")
      mi = described_class.ox_element("mi") << "x"
      mo = described_class.ox_element("mo") << "+"
      mn = described_class.ox_element("mn") << "1"

      described_class.update_nodes(row, [mi, nil, [mo, nil, [mn]], nil])
      expect(row.nodes.map(&:name)).to eq(%w[mi mo mn])
      expect(dumped(row)).to eq("<mrow><mi>x</mi><mo>+</mo><mn>1</mn></mrow>")
    end

    it "returns the element unchanged for a nil node list" do
      row = described_class.update_nodes(described_class.ox_element("mrow"), nil)
      expect(row.name).to eq("mrow")
      expect(row.nodes).to eq([])
    end

    it "returns the element unchanged for a list of nils" do
      row = described_class.update_nodes(described_class.ox_element("mrow"), [nil, nil])
      expect(row.nodes).to eq([])
    end

    it "appends plain strings as text children" do
      element = described_class.update_nodes(
        described_class.ox_element("mtext"), ["hello", nil, "world"]
      )
      expect(element.nodes).to eq(%w[hello world])
      expect(dumped(element)).to eq("<mtext>helloworld</mtext>")
    end
  end

  describe ".rpr_element" do
    it "builds a w:rPr with a Cambria Math w:rFonts child by default" do
      rpr = described_class.rpr_element
      expect(rpr.name).to eq("w:rPr")
      expect(rpr.nodes.map(&:name)).to eq(%w[w:rFonts])
      expect(dumped(rpr)).to eq(
        '<w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr>',
      )
    end

    it "appends a w:i child when wi_tag is true" do
      rpr = described_class.rpr_element(wi_tag: true)
      expect(rpr.nodes.map(&:name)).to eq(%w[w:rFonts w:i])
      expect(dumped(rpr)).to eq(
        '<w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr>',
      )
    end
  end

  describe ".pr_element" do
    it "builds <main>Pr in the given namespace wrapping an rpr element" do
      # mirrors the pervasive XmlHelper.pr_element("ctrl", true, namespace: "m")
      pr = described_class.pr_element("ctrl", true, namespace: "m")
      expect(pr.name).to eq("m:ctrlPr")
      expect(pr.nodes.map(&:name)).to eq(%w[w:rPr])
      expect(dumped(pr)).to eq(
        "<m:ctrlPr>" \
        '<w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/><w:i/></w:rPr>' \
        "</m:ctrlPr>",
      )
    end

    it "omits the w:i tag when wi_tag is not passed" do
      pr = described_class.pr_element("d", namespace: "m")
      expect(pr.name).to eq("m:dPr")
      expect(dumped(pr)).to eq(
        "<m:dPr>" \
        '<w:rPr><w:rFonts w:ascii="Cambria Math" w:hAnsi="Cambria Math"/></w:rPr>' \
        "</m:dPr>",
      )
    end

    it "builds an unprefixed tag for the default empty namespace" do
      pr = described_class.pr_element("box")
      expect(pr.name).to eq("boxPr")
    end
  end
end
