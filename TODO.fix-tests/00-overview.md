# MathML Spec Test Failures Investigation

## Summary
41 tests total: 22 passing, 19 failing
- 2 issues FIXED by current changes (Category 2 linebreak, Category 3 LaTeX part)
- These failures existed BEFORE mo_element fix and are pre-existing issues from lutaml-model update.

## Failure Categories

### Category 1: ZERO WIDTH SPACE serialization in OMML (7 tests)
**Tests:** 2452, 2913, 3039, 3121, 3201, 3365, 3486

**Issue:** `<m:t>&#8203;</m:t>` becomes `<m:t></m:t>` or `<m:t/>`

**Root Cause:** Ox serialization issue - empty elements serialized as `<m:t></m:t>` instead of `<m:t/>`

**Example diff:**
```
- <m:t/>
+ <m:t></m:t>
```

---

### Category 2: Linebreak positioning in HTML (FIXED)
**Tests:** 3594

**Issue:** `<br/>` positioned before operator instead of after

**Example diff:**
```
- <i>N</i><sub>s</sub><sup>2</sup> =<br/> T <br/>&#x2191; S <br/> D
+ <i>N</i><sub>s</sub><sup>2</sup> <br/>= T <br/>↑ S <br/> D
```

**Root Cause:** `linebreakstyle="after"` not being passed to Linebreak constructor.

**FIXED:** Now passes `linebreakstyle` attribute and uses `mathml_unary_classes` for proper encoding.

---

### Category 3: LaTeX whitespace in phantom (PARTIALLY FIXED)
**Tests:** 281

**Issue:** `\phantom{ y }` vs `\phantom{y}` - whitespace stripped from phantom content

**Example diff:**
```
- " x  \\phantom{+} \\phantom{ y } +  z "
+ "x \\phantom{+} \\phantom{y} + z"
```

**Root Cause:** Symbol class strips whitespace when creating symbol value.

**FIXED for LaTeX output:** After `mathml_unary_classes` creates Symbol, restore original value to preserve whitespace.
**Still failing:** MathML structure issue (mrow wrapper missing) - pre-existing bug.

---

### Category 4: MathML structure differences (8 tests)
**Tests:** 213, 778, 1197, 1272, 1319, 1366, 1540, 1713

**Issue:** XML structure differences with msubsup, mrow element positioning

**Example diff:**
```
Element_position differs: mrow at position 0 vs position 1
Element differs: msubsup → (empty)
```

**Root Cause:** Likely mml parsing issue with nested elements in semantics.

---

### Category 5: OMML rendering issues (3 tests)
**Tests:** 2559, 2663, 2790

**Issue:** limLow, accent, sSubSup not rendering correctly

**Example:** Expected limLow with proper lim printing, but got different structure.

**Root Cause:** Translator OMML rendering issues.

---

## Recommendations

### For Category 1 (ZERO WIDTH SPACE)
This is an Ox serialization issue. Empty elements are being serialized as `<m:t></m:t>` instead of `<m:t/>`.
Likely requires changes to how lutaml-model/Ox handles empty element serialization.

### For Category 2 (HTML linebreak) - FIXED
No further action needed.

### For Category 3 (Phantom whitespace) - PARTIALLY FIXED
LaTeX output is now correct. MathML structure issue requires investigation into mrow handling.

### For Category 4 (MathML structure)
Investigate mml parsing of semantics elements and how children are ordered.

### For Category 5 (OMML rendering)
Fix translator OMML rendering for limLow, accent, and sSubSup elements.
