# 07 - metanorma-cli-actions-mn-bipm (LaTeX structure)

## Test Location
`spec/plurimath/mathml_spec.rb:1713`

## Issue Summary
Test "contains input from metanorma-cli-actions-mn-bipm run" fails with LaTeX comparison.

## Expected LaTeX
`\underline{\mathit{B}} = \left [ ... \end{matrix}\right ]`

## Got LaTeX
`\underset{ \left ( \underline \right ) }{ \left ( \mathit{B} \right ) } = \left [ ... \end{matrix}\right ]`

## Issue
The LaTeX rendering of the underline/enclose structure is different - the structure of how `underline` wraps `B` has changed.

## Status
**Pre-existing from LutaML-Model update**
