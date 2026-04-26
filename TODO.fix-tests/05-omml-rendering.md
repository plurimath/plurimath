# Category 5: OMML Rendering Issues

## Affected Tests
- 2559: scarries, longdiv, msline and scarry tags
- 2663: underover, under, and over tags with displaystyle false
- 2790: bar, vec, dot, ddot, ul, and tilde examples containing accent

## Issue
OMML output has incorrect structure for limLow, accent, sSubSup elements.

## Example Issues
- `limLow` not rendering with proper lim printing
- Accent elements not properly structured
- sSubSup vs sSub/sSup structure issues

## Root Cause
Likely issues in the translator's OMML rendering methods for these specific elements.

## Investigation Needed
1. Check `PowerBase#to_omml_without_math_tag` for sSubSup handling
2. Check accent/overline rendering for OMML
3. Check nary functions (integral, product) OMML output

## Related Files
- `lib/plurimath/math/function/power_base.rb`
- `lib/plurimath/math/function/nary.rb`
- `lib/plurimath/mathml/translator.rb`
