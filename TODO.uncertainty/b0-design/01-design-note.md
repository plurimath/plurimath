# TODO 1 — Write the design note

## Why
Ronald's issue says what is missing, not what it should look like. A short note
with concrete examples is the cheapest way to agree on that before any code,
and it becomes the test plan for B1–B4.

## Scope
- **Sources:** GUM (JCGM 100:2008), with section references for each notation
  used. A readable source is `metanorma/mn-samples-jcgm`
  (`sources/jcgm/100-2008-en/`); relevant sections include 6.3.2 (coverage
  factor), 7.2.2 (reporting standard uncertainty, and why a bare `±` is
  ambiguous) and 7.2.3 (reporting expanded uncertainty).
- **What "GUM compliant" means here:** Plurimath *represents* reported
  uncertainty; it does not calculate it. The note lists the supported subset,
  which metadata is required, which may be unknown, and what is excluded. It
  never invents a confidence level from `k` alone (§6.3.2), and never lets
  standard and expanded uncertainty be confused.
- **Notations**, each with a GUM-cited example:
  - standard uncertainty: `x ± u`;
  - concise form: `1.234 56(12)`, uncertainty in the last digits;
  - expanded uncertainty: `U = k·u_c`, with the coverage factor `k` kept;
  - asymmetric: `x +a −b`.
- **Plain ± versus uncertainty:** one rule per input format. Default proposal:
  existing `+-` stays `Math::Symbols::Pm`; uncertainty needs an explicit form.
- **Model:** a node (working name `Math::Function::Uncertainty`) with value,
  uncertainty, kind (standard / expanded / asymmetric), optional `k`, optional
  coverage probability, and room for a unit.
- **Semantic cases**, each as input + context → expected model, output, or
  error:
  - concise form scaling: `1.23(4)` versus `1.230(4)` give different
    uncertainties;
  - trailing zeros, exponents, and the locale's decimal marker;
  - asymmetric parts;
  - invalid values (negative uncertainty, missing parts);
  - how it interacts with Plurimath's number formatting.
- **Per format**, for each notation: the exact output, whether input reads it
  back, and what is lost:
  - MathML (structure plus `intent`);
  - OMML;
  - UnicodeMath;
  - LaTeX (`\pm`, and siunitx-style for reference);
  - HTML (output);
  - AsciiMath (output in B2, input in B4).
- **Acceptance table:** every notation × every format, each cell labelled
  *lossless input*, *lossy input* (with the exact reduced form), *output only*,
  or *unsupported*, with the expected string. B1–B4's completion gates are
  derived from these labels.

## Done when
- [ ] The note exists, with the acceptance table filled for every notation and
      format.
- [ ] Every notation cites the GUM section it comes from.
- [ ] Suleman has reviewed it.
- [ ] It is shared with Ronald (how — issue comment or PR — is a remote write
      and needs approval then).
