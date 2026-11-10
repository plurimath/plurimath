"""Regenerate exact H.1 derivative and variance fixtures without the Ruby engine.
Run: python3 spec/support/gum_h1_reference.py
Profile input variances remain explicit in the fixture. No normative text copied.
"""
from fractions import Fraction as F
from pathlib import Path
import json

path = Path(__file__).resolve().parents[1] / "fixtures/evaluation/gum_h1.json"
data = json.loads(path.read_text())
n = 9
means = list(map(F, ["50000623", "215", "0", "0", "0.0000115", "-0.1", "0", "0", "0"]))

def term(indices):
    return tuple(indices.count(i) for i in range(n))

polynomial = {term([]): -F(50000000), term([0]): F(1), term([1]): F(1),
              term([2]): F(1), term([3]): F(1), term([0, 7, 5]): -F(1),
              term([0, 7, 6]): -F(1), term([0, 4, 8]): -F(1)}

def derivative(poly, i):
    result = {}
    for powers, coefficient in poly.items():
        if powers[i]:
            exponents = list(powers)
            exponents[i] -= 1
            result[tuple(exponents)] = coefficient * powers[i]
    return result

def evaluate(poly):
    result = F(0)
    for powers, coefficient in poly.items():
        for value, power in zip(means, powers):
            coefficient *= value ** power
        result += coefficient
    return result

data["estimate"] = str(evaluate(polynomial))
data["gradient"] = [str(evaluate(derivative(polynomial, i))) for i in range(n)]
data["hessian"] = [[str(evaluate(derivative(derivative(polynomial, i), j)))
                    for j in range(n)] for i in range(n)]
data["third"] = [[[str(evaluate(derivative(derivative(derivative(polynomial, i), j), k)))
                  for k in range(n)] for j in range(n)] for i in range(n)]
for profile in data["profiles"]:
    v = list(map(F, profile["variance"]))
    S, A, T = means[0], means[4], means[5]
    # Factored moment identity, independent of the derivative contraction.
    first = v[0] + sum(v[1:4]) + S*S*(v[7]*T*T + v[8]*A*A)
    correction = S*S*(v[7]*(v[5]+v[6]) + v[8]*v[4]) + v[0]*(T*T*v[7]+A*A*v[8])
    profile["first_variance"] = str(first)
    profile["second_variance"] = str(first + correction)
path.write_text(json.dumps(data, separators=(",", ":")) + "\n")
