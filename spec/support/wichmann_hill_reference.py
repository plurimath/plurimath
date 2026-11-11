"""Independent 32-bit JCGM101 C.3.3.2 recurrence; Ruby uses C.3.3.3.
Regenerate: python3 spec/support/wichmann_hill_reference.py
"""
from fractions import Fraction
from pathlib import Path
import json

a = (11600, 47003, 23000, 33000)
b = (185127, 45688, 93368, 65075)
c = (10379, 10479, 19423, 8123)
d = (2147483579, 2147483543, 2147483423, 2147483123)
initial = (12345, 23456, 34567, 45678)
state = list(initial)
rows = []
for _ in range(16):
    for j in range(4):
        quotient, remainder = divmod(state[j], b[j])
        state[j] = a[j]*remainder - c[j]*quotient
        if state[j] < 0:
            state[j] += d[j]
    w = sum((Fraction(x, m) for x, m in zip(state, d)), Fraction(0))
    uniform = w - w.numerator // w.denominator
    assert 0 < uniform < 1
    rows.append({"state": state[:], "uniform": str(uniform)})
path = Path(__file__).resolve().parents[1] / "fixtures/evaluation/wichmann_hill.json"
path.write_text(json.dumps({"seeds": initial, "source": "JCGM101:2008 C.3.3.2", "draws": rows}, separators=(",", ":"))+"\n")
