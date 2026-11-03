# frozen_string_literal: true

# Regenerates the generated regions of docs/asciimath.adoc from the amath
# grammar artifact and vocabulary, so the specification never restates the
# grammar or the symbol table by hand.
#
# Usage, from the Plurimath checkout:
#
#   bundle exec ruby scripts/docs/asciimath_tables.rb --amath PATH [--check]
#
# PATH is an amath checkout (git) at the revision being documented. The
# script verifies grammars/asciimath.parg and data/vocabulary.json against
# artifacts/asciimath.checksums.txt in that checkout and stops on any
# mismatch. It also reads the artifact of the amath gem Plurimath loads at
# run time (found through RubyGems, or given with --runtime-artifact) and
# requires its uncertainty rules to be byte-identical to the checkout's.
#
# Without --check it rewrites the regions between
# "// BEGIN GENERATED <name>" and "// END GENERATED <name>" in
# docs/asciimath.adoc. With --check it writes nothing and exits 1 when the
# file differs from what it would write. The output depends only on the
# input files and the amath revision, never on time or local paths.

require "digest"
require "json"
require "open3"

module AsciimathDocTables
  DOC = File.expand_path("../../docs/asciimath.adoc", __dir__)

  # Lexical rules quoted in the "Whitespace and numbers" section. Rules with
  # a decimal-marker suffix are quoted for the "dot" entry only; the other
  # entries differ in the marker alone.
  LEXICAL_RULES = %w[
    space space_opt comma digit
    decimal_marker__dot decimal_number__dot number__dot signed_number__dot
    hex_number binary_number octal_number
    base power frac_slash quoted_text
  ].freeze

  # The uncertainty rules: every rule whose name starts with one of these.
  UNCERTAINTY_PREFIXES = %w[unc_ uncertainty].freeze

  SYMBOL_SHAPES = {
    "word" => "ASCII letters only",
    "operator" => "ASCII punctuation only",
    "mixed" => "other ASCII spellings",
    "non-ascii" => "non-ASCII characters",
    "quoted" => "quoted names such as `\"P{name}\"`",
    "entity" => "numeric character references such as `+&#x2213;+`",
  }.freeze

  # Stands for a space inside a listed spelling, such as "\\ ".
  VISIBLE_SPACE = "\u2423"

  # Shapes listed in full; the other two are summarised by count.
  LISTED_SHAPES = %w[word operator mixed non-ascii].freeze

  class Error < StandardError; end

  module_function

  def run(argv)
    options = parse_args(argv)
    amath = options.fetch(:amath)
    sources = load_sources(amath)
    runtime = load_runtime(options[:runtime_artifact])
    unless runtime[:uncertainty] == sources[:uncertainty]
      raise Error, "the uncertainty rules of the runtime amath artifact " \
                   "(#{runtime[:version]}) differ from #{amath}"
    end

    regions = build_regions(sources, runtime)
    current = File.read(DOC, encoding: "UTF-8")
    updated = replace_regions(current, regions)
    return check(current, updated) if options[:check]

    File.write(DOC, updated) unless updated == current
    puts(updated == current ? "docs/asciimath.adoc is up to date" : "updated docs/asciimath.adoc")
    0
  end

  def check(current, updated)
    return 0 if current == updated

    warn "docs/asciimath.adoc is out of date; run scripts/docs/asciimath_tables.rb"
    1
  end

  def parse_args(argv)
    options = { check: false }
    args = argv.dup
    until args.empty?
      case (arg = args.shift)
      when "--amath" then options[:amath] = File.expand_path(args.shift.to_s)
      when "--runtime-artifact" then options[:runtime_artifact] = File.expand_path(args.shift.to_s)
      when "--check" then options[:check] = true
      else raise Error, "unknown argument #{arg.inspect}"
      end
    end
    raise Error, "--amath PATH is required" unless options[:amath]

    options
  end

  # The checkout's grammar and vocabulary, verified against its checksums.
  def load_sources(amath)
    checksums = parse_checksums(read(amath, "artifacts/asciimath.checksums.txt"))
    grammar = verified(amath, "grammars/asciimath.parg", checksums)
    vocabulary = verified(amath, "data/vocabulary.json", checksums)
    {
      revision: git_revision(amath),
      checksums: checksums,
      grammar: grammar,
      vocabulary: JSON.parse(vocabulary),
      uncertainty: rule_lines(grammar) { |name| uncertainty_rule?(name) },
      lexical: lexical_lines(grammar),
    }
  end

  def load_runtime(path)
    path ||= default_runtime_artifact
    artifact = JSON.parse(File.read(path, encoding: "UTF-8"))
    source = artifact.fetch("source")
    unless Digest::SHA256.hexdigest(source) == artifact.fetch("source_hash")
      raise Error, "#{path}: embedded source does not match its source_hash"
    end

    {
      version: runtime_version(path),
      checksum: artifact.fetch("checksum"),
      source_hash: artifact.fetch("source_hash"),
      compiler: artifact.fetch("compiler_version"),
      uncertainty: rule_lines(source) { |name| uncertainty_rule?(name) },
    }
  end

  def default_runtime_artifact
    spec = Gem::Specification.find_by_name("amath")
    File.join(spec.full_gem_path, "artifacts/asciimath.json")
  rescue Gem::MissingSpecError
    raise Error, "the amath gem is not installed; run under bundle exec or pass --runtime-artifact"
  end

  def runtime_version(path)
    spec = Gem::Specification.find { |s| path.start_with?(File.join(s.full_gem_path, "")) }
    spec ? spec.version.to_s : "artifact outside an installed gem"
  end

  def read(root, relative)
    File.read(File.join(root, relative), mode: "rb").force_encoding(Encoding::UTF_8)
  end

  def parse_checksums(text)
    text.each_line.with_object({}) do |line, map|
      next if line.start_with?("#")

      key, value, *rest = line.split
      map[key] = rest.empty? ? value : [value, *rest].join(" ") if key
    end
  end

  def verified(root, relative, checksums)
    bytes = read(root, relative)
    expected = checksums[relative]
    actual = "sha256:#{Digest::SHA256.hexdigest(bytes)}"
    raise Error, "#{relative} is not listed in artifacts/asciimath.checksums.txt" unless expected
    raise Error, "#{relative}: #{actual} does not match the recorded #{expected}" unless actual == expected

    bytes
  end

  def git_revision(root)
    out, status = Open3.capture2("git", "-C", root, "rev-parse", "HEAD")
    raise Error, "#{root} is not a git checkout" unless status.success?

    out.strip
  end

  def uncertainty_rule?(name)
    UNCERTAINTY_PREFIXES.any? { |prefix| name.start_with?(prefix) }
  end

  # Rule definitions, one per line in the generated grammar, in file order.
  def rule_lines(grammar)
    grammar.each_line.filter_map do |line|
      match = line.match(/\A {2}([a-z_0-9]+) = /)
      line.strip if match && yield(match[1])
    end
  end

  def lexical_lines(grammar)
    lines = rule_lines(grammar) { |name| LEXICAL_RULES.include?(name) }
    names = lines.map { |line| line.split(" = ", 2).first }
    missing = LEXICAL_RULES - names
    raise Error, "grammar has no rule #{missing.join(', ')}" unless missing.empty?

    lines.sort_by { |line| LEXICAL_RULES.index(line.split(" = ", 2).first) }
  end

  def build_regions(sources, runtime)
    {
      "provenance" => provenance(sources, runtime),
      "lexical-grammar" => source_block(sources[:lexical]),
      "uncertainty-grammar" => source_block(sources[:uncertainty]) +
        ["", "Checksum of the excerpt (lines joined by line feeds): `#{excerpt_digest(sources[:uncertainty])}`."],
      "vocabulary-summary" => vocabulary_summary(sources[:vocabulary]),
      "vocabulary-classes" => vocabulary_classes(sources[:vocabulary]),
      "vocabulary-symbols" => vocabulary_symbols(sources[:vocabulary]),
    }
  end

  def excerpt_digest(lines)
    "sha256:#{Digest::SHA256.hexdigest(lines.join("\n"))}"
  end

  def provenance(sources, runtime)
    sums = sources[:checksums]
    vocabulary = sources[:vocabulary]
    rows = [
      ["amath revision documented", sources[:revision]],
      ["`grammars/asciimath.parg`", sums["grammars/asciimath.parg"]],
      ["`data/vocabulary.json`", sums["data/vocabulary.json"]],
      ["vocabulary format", vocabulary.fetch("format")],
      ["vocabulary oracle (Plurimath revision)", vocabulary.dig("oracle", "revision")],
      ["artifact checksum (`artifacts/asciimath.json`)", sums["artifact_checksum"]],
      ["artifact compiler (Parsanol)", sums["compiler_version"]],
      ["artifact entries", sums["entries"]],
      ["runtime amath gem", runtime[:version]],
      ["runtime artifact checksum", runtime[:checksum]],
      ["runtime grammar source hash", "sha256:#{runtime[:source_hash]}"],
      ["runtime artifact compiler (Parsanol)", runtime[:compiler]],
      ["uncertainty rules, runtime vs documented revision", "byte-identical"],
    ]
    ['[cols="2,3"]', "|===", "|Item |Value", ""] +
      rows.map { |name, value| "|#{name} |`#{value}`" } +
      ["|==="]
  end

  def source_block(lines)
    ["[source]", "----", *lines, "----"]
  end

  def symbols(vocabulary)
    vocabulary.fetch("precompile_constants").filter_map do |word, category|
      word if category == "symbol"
    end
  end

  def symbol_shape(word)
    case word
    when /\A"[^"]*"\z/ then "quoted"
    when /\A(?:&#x[0-9a-fA-F]+;)+\z/ then "entity"
    when /\A[A-Za-z]+\z/ then "word"
    when /\A[\x21-\x7e]+\z/
      word.match?(/[A-Za-z0-9]/) ? "mixed" : "operator"
    when /\A[\x20-\x7e]+\z/ then "mixed"
    else "non-ascii"
    end
  end

  def vocabulary_summary(vocabulary)
    categories = vocabulary.fetch("precompile_constants").map(&:last).tally
    shapes = symbols(vocabulary).map { |word| symbol_shape(word) }.tally
    rows = categories.sort.map { |name, count| "|`#{name}` |all |#{count}" }
    rows += SYMBOL_SHAPES.map do |shape, text|
      "|`symbol` |#{text} |#{shapes.fetch(shape, 0)}"
    end
    ['[cols="1,2,1"]', "|===", "|Category |Spelling shape |Entries", "", *rows, "|==="]
  end

  def vocabulary_classes(vocabulary)
    constants = vocabulary.fetch("precompile_constants")
    lines = []
    %w[unary_class fonts special_fonts].each do |category|
      words = constants.filter_map { |word, kind| word if kind == category }
      lines.concat(wrapped("#{category} (#{words.length})", words.sort))
    end
    %w[binary_classes ternary_classes sub_sup_classes unary_underscore_words].each do |key|
      words = vocabulary.fetch(key)
      lines.concat(wrapped("#{key} (#{words.length})", words.sort))
    end
    lines.concat(wrapped("parenthesis", pairs(vocabulary.fetch("parenthesis"))))
    lines.concat(wrapped("table_parenthesis", pairs(vocabulary.fetch("table_parenthesis"))))
    lines.concat(wrapped("decimal_markers", vocabulary.fetch("decimal_markers").map { |m| codepoint(m) }))
    lines.concat(wrapped("base_number_prefix", vocabulary.fetch("base_number_prefix").keys))
    ["....", *lines, "...."]
  end

  def vocabulary_symbols(vocabulary)
    by_shape = symbols(vocabulary).group_by { |word| symbol_shape(word) }
    lines = LISTED_SHAPES.flat_map do |shape|
      words = by_shape.fetch(shape, []).sort.map { |word| word.gsub(" ", VISIBLE_SPACE) }
      wrapped("#{shape} (#{words.length})", words)
    end
    ["....", *lines, "...."]
  end

  def pairs(list)
    list.map { |open, close| "#{display(open)} #{display(close)}" }
  end

  # Characters the grammar uses internally for :( :) {: :} are shown as
  # their code points, which is how the grammar names them.
  def display(char)
    char.match?(/\A[\x21-\x7e]\z/) ? char : codepoint(char)
  end

  def codepoint(char)
    format("U+%04X", char.ord)
  end

  # A heading line, then the words in columns of a fixed width.
  def wrapped(title, words, width: 78)
    lines = ["#{title}:"]
    cell = [words.map(&:length).max.to_i + 2, 4].max
    per_line = [(width - 2) / cell, 1].max
    words.each_slice(per_line) do |slice|
      lines << "  #{slice.map { |word| word.ljust(cell) }.join.rstrip}"
    end
    lines << ""
  end

  def replace_regions(text, regions)
    regions.reduce(text) do |doc, (name, lines)|
      pattern = %r{(^// BEGIN GENERATED #{Regexp.escape(name)}\n).*?(^// END GENERATED #{Regexp.escape(name)}$)}m
      raise Error, "docs/asciimath.adoc has no generated region #{name.inspect}" unless doc.match?(pattern)

      doc.sub(pattern) { "#{Regexp.last_match(1)}#{lines.join("\n")}\n#{Regexp.last_match(2)}" }
    end
  end
end

if $PROGRAM_NAME == __FILE__
  begin
    exit AsciimathDocTables.run(ARGV)
  rescue AsciimathDocTables::Error => e
    warn "asciimath_tables: #{e.message}"
    exit 2
  end
end
