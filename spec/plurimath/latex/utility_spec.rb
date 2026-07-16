require "spec_helper"

# Characterization specs (phase A0 of the language-utility split).
#
# These examples pin the CURRENT behavior of the LaTeX-side table/symbol
# helpers before they move to language-specific utility modules.
# Expectations were derived by running the code, not from intent — oddities
# are pinned as-is and flagged with `# quirk:` comments rather than "fixed".
RSpec.describe Plurimath::Latex::Utility do
  def number(value)
    Plurimath::Math::Number.new(value)
  end

  def td(values, options = nil)
    Plurimath::Math::Function::Td.new(values, options)
  end

  def tr(tds)
    Plurimath::Math::Function::Tr.new(tds)
  end

  def slice(string)
    Parslet::Slice.new(Parslet::Position.new(string, 0), string)
  end

  def ampersand
    Plurimath::Math::Symbols::Ampersand.new
  end

  def linebreak
    Plurimath::Math::Function::Linebreak.new
  end

  describe ".organize_table" do
    it "wraps a separator-free array into a single Tr containing a single Td" do
      result = described_class.organize_table([number("1"), number("2")])

      expect(result).to eq([tr([td([number("1"), number("2")])])])
    end

    it "splits cells on Ampersand and rows on Linebreak" do
      result = described_class.organize_table(
        [
          number("1"), ampersand, number("2"), linebreak,
          number("3"), ampersand, number("4")
        ],
      )

      expect(result).to eq(
        [
          tr([td([number("1")]), td([number("2")])]),
          tr([td([number("3")]), td([number("4")])]),
        ],
      )
    end

    it "splits cells on a generic Symbol whose value is '&'" do
      result = described_class.organize_table(
        [number("1"), Plurimath::Math::Symbols::Symbol.new("&"), number("2")],
      )

      expect(result).to eq([tr([td([number("1")]), td([number("2")])])])
    end

    # A trailing linebreak closes the last row; nothing follows it, so it no
    # longer leaves an empty row behind.
    it "does not append an empty row after a trailing Linebreak" do
      result = described_class.organize_table([number("1"), linebreak])

      expect(result).to eq([tr([td([number("1")])])])
    end

    # An empty input yields the placeholder: one row holding a single empty Td.
    it "returns one row with one empty Td for an empty array" do
      expect(described_class.organize_table([])).to eq([tr([td([])])])
    end

    # The trailing-linebreak guard's remaining states, pinned by row/cell shape.
    it "appends an empty padding cell for a trailing separator" do
      expect(described_class.organize_table([number("1"), ampersand]))
        .to eq([tr([td([number("1")]), td([])])])
    end

    it "yields one empty-Td row for a lone Linebreak" do
      expect(described_class.organize_table([linebreak])).to eq([tr([td([])])])
    end

    it "yields one empty-Td row per Linebreak for consecutive Linebreaks" do
      expect(described_class.organize_table([linebreak, linebreak]))
        .to eq([tr([td([])]), tr([td([])])])
    end

    it "pads the separator's row when a separator follows a Linebreak" do
      expect(described_class.organize_table([linebreak, ampersand]))
        .to eq([tr([td([])]), tr([td([]), td([])])])
    end

    it "closes a separator-opened row on a trailing Linebreak" do
      expect(described_class.organize_table([ampersand, linebreak]))
        .to eq([tr([td([]), td([])])])
    end

    # quirk: Minus merging (filter_table_data) only runs on cells flushed by
    # a separator; a Minus followed by a value inside such a cell is folded
    # into a nested Formula([minus, next_object]).
    it "merges Minus with its next sibling into a Formula in separator-flushed cells" do
      minus = Plurimath::Math::Symbols::Minus.new
      result = described_class.organize_table(
        [number("1"), minus, number("2"), ampersand, number("3")],
      )

      expect(result).to eq(
        [
          tr(
            [
              td(
                [
                  number("1"),
                  Plurimath::Math::Formula.new(
                    [Plurimath::Math::Symbols::Minus.new, number("2")],
                  ),
                ],
              ),
              td([number("3")]),
            ],
          ),
        ],
      )
    end

    # quirk: filter_table_data runs only on separator-flushed cells, so the
    # final post-loop cell leaves a Minus and its next sibling unmerged.
    it "does not merge Minus in the final (post-loop) cell" do
      result = described_class.organize_table(
        [Plurimath::Math::Symbols::Minus.new, number("2")],
      )

      expect(result).to eq(
        [tr([td([Plurimath::Math::Symbols::Minus.new, number("2")])])],
      )
    end

    it "applies column_align letters as Td columnalign attributes" do
      result = described_class.organize_table(
        [number("1"), ampersand, number("2")],
        column_align: [
          Plurimath::Math::Symbols::Symbol.new("c"),
          Plurimath::Math::Symbols::Symbol.new("r"),
        ],
      )

      expect(result).to eq(
        [
          tr(
            [
              td([number("1")], { columnalign: "center" }),
              td([number("2")], { columnalign: "right" }),
            ],
          ),
        ],
      )
    end

    it "treats an empty column_align like no column_align" do
      result = described_class.organize_table([number("1")], column_align: [])

      expect(result).to eq([tr([td([number("1")])])])
    end

    it "inserts a Td([Vert]) separator cell for a Paren in column_align" do
      result = described_class.organize_table(
        [number("1"), ampersand, number("2")],
        column_align: [
          Plurimath::Math::Symbols::Paren::Vert.new,
          Plurimath::Math::Symbols::Symbol.new("c"),
          Plurimath::Math::Symbols::Symbol.new("r"),
        ],
      )

      expect(result).to eq(
        [
          tr(
            [
              td([Plurimath::Math::Symbols::Paren::Vert.new]),
              td([number("1")], { columnalign: "center" }),
              td([number("2")], { columnalign: "right" }),
            ],
          ),
        ],
      )
    end

    it "replicates a single column_align across every Td when options is truthy" do
      column_align = [Plurimath::Math::Symbols::Symbol.new("c")]
      result = described_class.organize_table(
        [number("1"), ampersand, number("2")],
        column_align: column_align,
        options: true,
      )

      expect(result).to eq(
        [
          tr(
            [
              td([number("1")], { columnalign: "center" }),
              td([number("2")], { columnalign: "center" }),
            ],
          ),
        ],
      )
      expect(column_align).to eq([Plurimath::Math::Symbols::Symbol.new("c")])
    end

    # quirk: with options and more than one column_align entry,
    # organize_options shifts the first align away (its return value is
    # discarded), mutates column_align in place, and injects the remaining
    # align symbols into the data array — so "r" becomes cell content AND
    # the alignment applied to every Td.
    it "drops the first align and injects the rest as data when options is truthy with multiple aligns" do
      column_align = [
        Plurimath::Math::Symbols::Symbol.new("c"),
        Plurimath::Math::Symbols::Symbol.new("r"),
      ]
      array = [number("1"), ampersand, number("2")]
      result = described_class.organize_table(
        array,
        column_align: column_align,
        options: true,
      )

      expect(result).to eq(
        [
          tr(
            [
              td(
                [Plurimath::Math::Symbols::Symbol.new("r"), number("1")],
                { columnalign: "right" },
              ),
              td([number("2")], { columnalign: "right" }),
            ],
          ),
        ],
      )
      expect(column_align).to eq([Plurimath::Math::Symbols::Symbol.new("r")])
      expect(array.length).to eq(4)
    end
  end

  describe ".table_options" do
    it "returns a rowline entry marking Hline-led rows as solid" do
      table = [
        tr([td([Plurimath::Math::Symbols::Hline.new]), td([number("9")])]),
        tr([td([number("1")])]),
      ]

      expect(described_class.table_options(table)).to eq({ rowline: "solid none" })
    end

    it "marks non-leading Hline rows in document order" do
      table = [
        tr([td([number("1")])]),
        tr([td([Plurimath::Math::Symbols::Hline.new])]),
      ]

      expect(described_class.table_options(table)).to eq({ rowline: "none solid" })
    end

    it "returns an empty hash when no row starts with Hline" do
      table = [tr([td([number("1")])]), tr([td([])])]

      expect(described_class.table_options(table)).to eq({})
    end

    it "returns an empty hash for an empty table" do
      expect(described_class.table_options([])).to eq({})
    end
  end

  describe ".table_td" do
    it "wraps an existing Td in an array without re-wrapping it" do
      existing = td([number("1")])
      result = described_class.table_td(existing)

      expect(result).to eq([td([number("1")])])
      expect(result.first).to be(existing)
    end

    it "wraps a non-Td object in a new Td" do
      expect(described_class.table_td(number("5"))).to eq([td([number("5")])])
    end

    # nil is not content, so it is filtered out rather than becoming a cell
    # holding a nil.
    it "wraps nil into an empty Td" do
      expect(described_class.table_td(nil)).to eq([td([])])
    end
  end

  describe ".left_right_objects" do
    it "builds a Left function from a plain paren via LEFT_RIGHT_PARENTHESIS" do
      expect(described_class.left_right_objects("(", "left")).to eq(
        Plurimath::Math::Function::Left.new("("),
      )
    end

    it "builds a Right function from a plain paren" do
      expect(described_class.left_right_objects(")", "right")).to eq(
        Plurimath::Math::Function::Right.new(")"),
      )
    end

    it "strips backslashes from escaped curly parens instead of using the lookup" do
      expect(described_class.left_right_objects("\\{", "left")).to eq(
        Plurimath::Math::Function::Left.new("{"),
      )
      expect(described_class.left_right_objects("\\}", "right")).to eq(
        Plurimath::Math::Function::Right.new("}"),
      )
    end

    it "maps named delimiters to their HTML entity" do
      expect(described_class.left_right_objects("\\langle", "left")).to eq(
        Plurimath::Math::Function::Left.new("&#x2329;"),
      )
      expect(described_class.left_right_objects("\\lfloor", "left")).to eq(
        Plurimath::Math::Function::Left.new("&#x230a;"),
      )
    end

    it "accepts Parslet::Slice input" do
      expect(described_class.left_right_objects(slice("("), "left")).to eq(
        Plurimath::Math::Function::Left.new("("),
      )
    end

    # quirk: an unrecognized delimiter does not raise — the lookup returns
    # nil and a paren-less Left is built.
    it "builds a Left with nil paren for an unknown delimiter" do
      expect(described_class.left_right_objects("unknown", "left")).to eq(
        Plurimath::Math::Function::Left.new(nil),
      )
    end
  end
end
