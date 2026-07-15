# TODO — PR #448 audit (lasem image rendering)

Source: audit performed 2026-06-29 against `feat/lasem-image-rendering` (HEAD `c0a7729c`).
Author: suleman-uzair. +792/−57. DRAFT. CI green.

Scope: `Plurimath::Math.render`, `Formula#render`, `plurimath render` CLI,
`Plurimath::RenderingError`, `Plurimath::Math::Renderer` (lasem bridge).

---

## Blockers (must fix before merge)

### H1. Rename `Plurimath::RenderingError` → `Plurimath::Errors::RenderingError`
- File: `lib/plurimath/errors/rendering_error.rb:4` declares `class RenderingError < Error` under `Plurimath`, not `Plurimath::Errors`.
- Move autoload from `lib/plurimath.rb:16` into `lib/plurimath/errors.rb`.
- Update references: README.adoc (2 callouts), `spec/plurimath/math/renderer_spec.rb`, `spec/plurimath/math/formula/render_spec.rb`, `spec/plurimath/math_spec.rb`.
- Precedent: `Plurimath::Errors::UnsupportedBase`, `Errors::InvalidNumber`, `Errors::UnsupportedLocale`. See memory `feedback-errors-namespace`.

### H2. Replace `require_relative` with `autoload`
- `lib/plurimath/cli.rb:5-7` — `require_relative "cli/helpers"`, `"cli/convert"`, `"cli/render"`.
- `lib/plurimath/cli/helpers.rb:26,29` — `require_relative "../setup/ox_engine"`, `"../setup/oga"`.
- Add `autoload :Convert, "plurimath/cli/convert"` etc. on `class Cli < Thor`.

### H3. Rebase on `main`; re-apply #452's boolean coercion
- `lib/plurimath/cli/convert.rb:17` still has `YAML.safe_load(options[:math_rendering])`.
- Replace with `options[:math_rendering].to_s == "true"` (matches `Formula#boolean_display_style`).
- Without this, the Opal path #452 fixed is broken again.

### M1. Memoize `Renderer.available?`
- `lib/plurimath/math/renderer.rb:48-58` clears `@load_error` and re-runs `load_lasem` (which `require "lasem"`'s) on every call.
- `Math.render_available?` may be polled by callers — each call re-requires.
- Refactor: resolve load state once, return a result struct; make `available?` a pure query.

### M5. CLI rescue parity between `convert` and `render`
- `lib/plurimath/cli/render.rb:14-16` rescues `Plurimath::Error`; `Cli::Convert#call` has no rescue.
- `plurimath convert -i '{\sin{d}' -f latex` → uncaught backtrace.
- `plurimath render -i '{\sin{d}' -f latex -o x.png` → clean message + `exit 1`.
- Decide: both rescue via a shared helper (preferred), or neither. Consider distinct exit codes (parse: 65 `EX_DATAERR`; render: 70 `EX_SOFTWARE`).

---

## Strongly request changes

### M2. Unify option routing
- Three option lists across three files: `Math.SUPPORTED_PARSE_OPTIONS`, `Renderer::MATHML_OPTIONS`, `Renderer::LASEM_OPTIONS`.
- `Cli::Render#render_options` reads `Renderer::LASEM_OPTIONS` even though `Renderer` is documented NOT public API (`renderer.rb:8`).
- Decide: either `LASEM_OPTIONS` is public (say so), or move the canonical option registry onto `Math`.
- Inconsistency: `Math.parse` raises `ParseOptionError` on unknown opts; `Formula#render` silently drops unknown opts (spec `"ignores unrecognized keyword options"` codifies this). Pick one — raising is more useful for a public API.

### L3. Spec gaps to close
- `Formula#render` with `split_on_linebreak: true` — the docstring warns it breaks lasem; no spec covers it. Either add one or stop forwarding the option to `to_mathml` in the render path.
- `Math.render` with `locale:` AND lasem geometry together — only routing is tested, not the combined path.
- `Cli::Render` with `-p`/`--file-input` — only `-i` is tested.
- `Cli::Render` writing real bytes to `--output` — every test stubs `Math.render`.
- `Cli::Convert` as standalone command object (`Cli::Convert.new(options).call`) — the new architecture's selling point, not directly tested.
- `Renderer.available?` memoization behavior (becomes relevant after M1).

---

## Follow-ups (can be separate PRs)

### M3. `Cli::Convert#convert_formula` case statement (OCP)
- `lib/plurimath/cli/convert.rb:25-32` relocated pre-existing case dispatch.
- Adding a format requires touching this case AND `Formula` AND `Math::VALID_TYPES`.
- Consider `formula.public_send(:"to_#{output_format}")` with whitelist from `Math::VALID_TYPES`.

### M4. CLI option declaration duplication
- `convert` and `render` both declare `:input`, `:input_format`, `:file_path`, `:xml_engine`, `:display_style`, `:split_on_linebreak` (~25 lines duplicated).
- Use Thor `class_option`, or a shared module.

### M6. `Cli::Render#render_format` defers invalid-extension errors
- `lib/plurimath/cli/render.rb:38-46` returns `:gif` verbatim for unknown extensions and relies on `Renderer.normalize_format` to raise.
- Two error paths for the same kind of mistake. Validate at the CLI boundary; source supported set from `Renderer::OUTPUT_FORMATS`.

### L1. Drop pointless `super()` in `Helpers#initialize`
- `lib/plurimath/cli/helpers.rb:13-16`. `Convert`/`Render` are plain `Object` subclasses; `super()` calls `Object#initialize` (no-op).

### L2. Remove `send` calls to private methods in specs
- `spec/plurimath/cli_spec.rb:142,154` — `cmd.send(:render_options)`, `... .send(:render_format, ...)`.
- Either test through the public path (`Cli.start([...])`) or promote `render_format` to a tiny standalone module/class so it can be tested directly.

### L4. Fix parallel-unsafe tmp paths in specs
- `spec/plurimath/cli_spec.rb:8` uses `Process.pid`. Use `Tempfile` or `SecureRandom.hex(4)` suffix.

### L6. Note Opal autoload assumption
- `lib/plurimath/math/renderer.rb:11-13` claims autoload guarantees Opal won't bundle the file. This depends on Opal's compiler behavior. Add a comment noting it's empirical, not structural.

---

## Open architectural question

`Math` → `Formula#render` → `Renderer` → `Lasem` is three layers for "serialize to MathML, then rasterize." `Formula#render` is mostly option-slicing; `Math.render` is mostly option-routing; only `Renderer` does work.

Should rendering live on `Formula` at all? A service shape — `Plurimath::Render.call(formula, format: :png, ppi: 144)` — would keep the pure-math domain model free of native-extension / image-byte concerns. Decide before this becomes 1.x public API.

---

## Done well (no changes needed)

- Soft-dep gating: `lasem` is not in the gemspec, only required inside `Renderer.load_lasem`.
- Opal excluded via `RUBY_ENGINE` short-circuit at `available?` and `render_available?`.
- Single bridge point — library depends on `Plurimath::Math::Renderer` constant, never on `Lasem` directly.
- Actionable error messages (`gem \"lasem\"`, `lasem-doctor`).
- Error factory methods (`unsupported_format`, `unavailable`, `render_failed`) match `ParseOptionError.unknown_options` pattern.
- `Cli::Convert` / `Cli::Render` as standalone command objects — testable without Thor.
- Stubbed-backend specs use real `Class.new`, not doubles.
