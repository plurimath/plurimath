"""Independent 80-digit reference; requires mpmath==1.3.0 (development only).
Runtime Ruby uses erf and adaptive density quadrature, not incomplete beta.
Run: python3 spec/support/gum_statistics_reference.py
"""
from pathlib import Path
import json
import mpmath as mp
assert mp.__version__ == "1.3.0"
mp.mp.dps = 80

def text(x):
    return mp.nstr(x, 65)

def normal(x):
    return mp.erfc(-x/mp.sqrt(2))/2

def tcdf(x, nu):
    # Substitution x=sqrt(nu)*tan(theta) in the normalized t density.
    return (1 + mp.betainc(mp.mpf("0.5"), nu/2, 0, x*x/(nu+x*x), regularized=True))/2

def quantile(p, nu):
    target = (1+p)/2
    if nu is None:
        return mp.sqrt(2)*mp.erfinv(p)
    lower, upper = mp.mpf(0), mp.mpf(1)
    while tcdf(upper, nu) < target:
        upper *= 2
    for _ in range(300):
        midpoint = (lower+upper)/2
        if tcdf(midpoint, nu) < target:
            lower = midpoint
        else:
            upper = midpoint
    return (lower+upper)/2

coverage=[]
for p, nu in [("0.5",None),("0.9",None),("0.95",None),("0.99",None),("0.999",None),
              ("0.95","1"),("0.95","2"),("0.95","2.5"),("0.95","5"),("0.95","10"),
              ("0.95","100"),("0.95","10000"),("0.999","1")]:
    factor=quantile(mp.mpf(p),None if nu is None else mp.mpf(nu))
    coverage.append({"probability":p,"degrees_of_freedom":nu,"factor":text(factor),"expanded_u2":text(2*factor)})

table=[]
for p,z in [("0.80","0.84"),("0.90","1.28"),("0.95","1.64"),("0.99","2.33"),("0.999","3.09")]:
    table.append({"published_pc":p,"published_rounded_z":z,"pc_at_rounded_z":text(normal(mp.mpf(z)))})

def pc(mean,u,lower,upper):
    l=mp.mpf(0) if lower is None else normal((mp.mpf(lower)-mp.mpf(mean))/mp.mpf(u))
    r=mp.mpf(1) if upper is None else normal((mp.mpf(upper)-mp.mpf(mean))/mp.mpf(u))
    return r-l

cases=[]
for identifier,mean,u,lower,upper in [("diode","-5.47","0.05",None,"-5.40"),
    ("burst","509.7","8.6","490",None),("iso_cm1","0","1","-2","2"),
    ("iso_cm2_boundary","2","1","-4","4"),("guarded_rejection","3","1",None,"0")]:
    probability=pc(mean,u,lower,upper)
    cases.append({"id":identifier,"estimate":mean,"u":u,"lower":lower,"upper":upper,
                  "pc":text(probability),"nonconformance":text(1-probability)})
q=quantile(mp.mpf("0.95"),None)
output={"schema":"gum-statistics-reference/1","mpmath_version":mp.__version__,"working_decimal_digits":80,
        "coverage":coverage,"jcgm106_table1":table,"conformity":cases,
        "normal_identity_mcm":{"mean":"3","sd":"2","probability":"0.95","lower":text(3-2*q),"upper":text(3+2*q)}}
path=Path(__file__).resolve().parents[1]/"fixtures/evaluation/gum_statistics.json"
path.write_text(json.dumps(output,separators=(",",":"))+"\n")
