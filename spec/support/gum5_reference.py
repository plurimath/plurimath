"""Independent GUM5 references: 80-digit roots/differentiation and factored moments.
Requires development-only mpmath1.3.0; no runtime evaluator is imported.
"""
from pathlib import Path
from fractions import Fraction as F
import json
import mpmath as mp
mp.mp.dps=80
root=Path(__file__).resolve().parents[1]/"fixtures"/"evaluation"
data=json.loads((root/"gum5_inputs.json").read_text())
m=lambda x:mp.mpf(str(x))
thermal=data["thermometer"]
r0,a,b,rs=map(m,[thermal[k] for k in ["R0","A","B","RS"]])
ratios=list(map(m,thermal["W"]))
# Explicit root differentiation is independent of the runtime's implicit solve.
def temperature(r,a,b,s,w):
    return 2*(w*s/r-1)/(a+mp.sqrt(a*a+4*b*(w*s/r-1)))
estimates=[temperature(r0,a,b,rs,w) for w in ratios]
u=list(map(m,thermal["standard_uncertainties"]))
n=4+len(ratios)
cov=mp.matrix(n,n)
for i in range(n):cov[i,i]=u[i if i<4 else 4]**2
for i in range(3):
    for j in range(3):cov[i,j]=u[i]*u[j]*m(thermal["parameter_correlations"][i][j])
rows=[]
for k,w in enumerate(ratios):
    sensitivities=[mp.diff(lambda z:temperature(z,a,b,rs,w),r0),mp.diff(lambda z:temperature(r0,z,b,rs,w),a),mp.diff(lambda z:temperature(r0,a,z,rs,w),b),mp.diff(lambda z:temperature(r0,a,b,z,w),rs)]
    sensitivities += [mp.diff(lambda z:temperature(r0,a,b,rs,z),w) if j==k else mp.mpf(0) for j in range(len(ratios))]
    rows.append(sensitivities)
outcov=mp.matrix(rows)*cov*mp.matrix(rows).T
thermometer={"estimates":estimates,"input_covariance":[list(cov[i,:]) for i in range(n)],"output_covariance":[list(outcov[i,:]) for i in range(len(ratios))],"standard_uncertainties":[mp.sqrt(outcov[i,i]) for i in range(len(ratios))]}
loss=[]
for correlation in data["comparison_loss"]["correlations"]:
    for x in data["comparison_loss"]["x1"]:
        v=F(data["comparison_loss"]["standard_uncertainty"])**2
        rho=F(correlation);mu=F(x)
        # Exact noncentral quadratic Gaussian moments for X1^2+X2^2.
        loss.append({"x1":x,"correlation":correlation,"mean":mu**2+2*v,"variance":4*mu**2*v+4*v*v*(1+rho*rho),"lpu_estimate":mu**2,"lpu_variance":4*mu**2*v})
mass=data["mass_calibration"];mu=sum(map(m,mass["mass_means_mg"]));vm=sum(x*x for x in map(m,mass["mass_standard_uncertainties_mg"]))
centers=list(map(m,mass["density_means_kg_m3"]));widths=list(map(m,mass["density_half_widths_kg_m3"]))
def reciprocal_moments(center,width):
    lo,hi=center-width,center+width
    return mp.log(hi/lo)/(hi-lo),1/(lo*hi)
ew,ew2=reciprocal_moments(centers[1],widths[1]);er,er2=reciprocal_moments(centers[2],widths[2])
variance=vm+(mu*mu+vm)*widths[0]**2/3*(ew2+er2-2*ew*er)
massref={"mean":mu-m(mass["nominal_mass_mg"]),"variance":variance,"standard_uncertainty":mp.sqrt(variance),"lpu_variance":vm,"moment_method":"independent reciprocal-uniform moments; centered air density has zero mean"}
linear=[{"distribution":dist,"variance":sum(F(x)**2 for x in uncertainties)} for dist,uncertainties in zip(data["linear_sum"]["distributions"],data["linear_sum"]["standard_uncertainties"])]
def serialize(x):
    if isinstance(x,F):return str(x)
    if isinstance(x,mp.mpf):return mp.nstr(x,75)
    if isinstance(x,list):return [serialize(y) for y in x]
    if isinstance(x,dict):return {k:serialize(v) for k,v in x.items()}
    return x
bromine_data=json.loads((root/"gum6_bromine.json").read_text())
sigma=F(bromine_data["standard_uncertainty"]);mu=F(bromine_data["estimate"])
bromine={"mean":2*mu*(1-mu)-2*sigma*sigma,"variance":(2-4*mu)**2*sigma*sigma+8*sigma**4,"lpu_variance":(2-4*mu)**2*sigma*sigma}
out={"schema":"GUM5-independent-references/1","mpmath_version":mp.__version__,"decimal_precision":80,"thermometer":thermometer,"comparison_loss":loss,"mass_calibration":massref,"linear_sum":linear,"bromine":bromine}
(root/"gum5_reference.json").write_text(json.dumps(serialize(out),separators=(",",":"))+"\n")
