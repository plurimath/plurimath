"""Independent AnnexH numeric reference; development dependency mpmath1.3.0.
Uses centered least-squares and explicit sample moments rather than runtime
normal equations; trigonometric/exponential functions use80-digit mpmath.
"""
from pathlib import Path
from fractions import Fraction as F
from itertools import product
from math import prod
import json
import mpmath as mp
assert mp.__version__ == "1.3.0"
mp.mp.dps=80
root=Path(__file__).resolve().parents[1]/"fixtures/evaluation"
data=json.loads((root/"gum_annex_h.json").read_text())
q=lambda x:F(str(x))
m=lambda x:mp.mpf(x.numerator)/x.denominator if isinstance(x,F) else mp.mpf(str(x))
text=lambda x:mp.nstr(x,65) if isinstance(x,mp.mpf) else str(x)

def paired(rows):
    n=len(rows)
    means=[sum(col)/n for col in zip(*rows)]
    cov=[[sum((row[i]-means[i])*(row[j]-means[j]) for row in rows)/(n*(n-1))
          for j in range(len(means))] for i in range(len(means))]
    return means,cov

def corr(cov):
    return [[cov[i][j]/mp.sqrt(cov[i][i]*cov[j][j]) for j in range(len(cov))] for i in range(len(cov))]

def transform(jac,cov):
    return [[sum(a[i]*m(cov[i][j])*b[j] for i in range(len(a)) for j in range(len(b))) for b in jac] for a in jac]

rows=[[q(x) for x in row] for row in data['h2']['observations']]
mu,cov=paired(rows)
v,i,p=map(m,mu);z=1000*v/i
values=[z*mp.cos(p),z*mp.sin(p),z]
jac=[[1000*mp.cos(p)/i,-1000*v*mp.cos(p)/i**2,-z*mp.sin(p)],
     [1000*mp.sin(p)/i,-1000*v*mp.sin(p)/i**2,z*mp.cos(p)],
     [1000/i,-1000*v/i**2,mp.mpf(0)]]
output_cov=transform(jac,cov)
point_values=[]
for v,i,p in [[m(x) for x in row] for row in rows]:
    z=1000*v/i;point_values.append([z*mp.cos(p),z*mp.sin(p),z])
mean2,cov2=paired(point_values)
h2={'means':mu,'input_covariance':cov,'approach1':{'estimates':values,'jacobian':jac,'covariance':output_cov,'uncertainties':[mp.sqrt(output_cov[i][i]) for i in range(3)],'correlations':corr(output_cov)},'approach2':{'estimates':mean2,'covariance':cov2,'uncertainties':[mp.sqrt(cov2[i][i]) for i in range(3)]}}
summary=data['h2'];us=list(map(q,summary['rounded_summary_uncertainties']));rho=[[q(x) for x in row] for row in summary['rounded_summary_correlations']]
rounded_cov=[[us[i]*us[j]*rho[i][j] for j in range(3)] for i in range(3)]
rounded_output=transform(jac,rounded_cov)
h2['rounded_summary_input_covariance']=rounded_cov
h2['rounded_summary_uncertainties']=[mp.sqrt(rounded_output[i][i]) for i in range(3)]


x=list(map(q,data['h3']['temperatures_C']));y=list(map(q,data['h3']['corrections_C']));n=len(x);t0=q(data['h3']['reference_temperature_C'])
xbar=sum(x)/n;ybar=sum(y)/n;sxx=sum((v-xbar)**2 for v in x)
slope=sum((a-xbar)*(b-ybar) for a,b in zip(x,y))/sxx
intercept=ybar-slope*(xbar-t0)
residual=[b-ybar-slope*(a-xbar) for a,b in zip(x,y)]
variance=sum(v*v for v in residual)/(n-2)
cov3=[[variance*(F(1,n)+(xbar-t0)**2/sxx),-variance*(xbar-t0)/sxx],[-variance*(xbar-t0)/sxx,variance/sxx]]
t=q(data['h3']['prediction_temperature_C']);prediction=ybar+slope*(t-xbar);predvar=variance*(F(1,n)+(t-xbar)**2/sxx)
h3={'intercept':intercept,'slope':slope,'covariance':cov3,'residual_variance':variance,'correlation':m(cov3[0][1])/mp.sqrt(m(cov3[0][0]*cov3[1][1])),'prediction':prediction,'prediction_variance':predvar,'prediction_u':mp.sqrt(m(predvar))}

h=data['h4'];lam=m(q(h['decay_constant_per_min']));duration=m(q(h['counting_time_min']));rates=[];ratios=[]
for row in h['observations']:
    ts,cs,tb,cb,tx,cx=map(q,row)
    rx=m(cx-cb)/duration*mp.exp(lam*m(tx));rs=m(cs-cb)/duration*mp.exp(lam*m(ts));rates.append([rx,rs]);ratios.append(rx/rs)
rmu,rcov=paired(rates);rmean,ratio_cov=paired([[r] for r in ratios]);a,ms,mx=[m(q(h[k])) for k in ['standard_activity_Bq_per_g','standard_mass_g','sample_mass_g']]
au,msu,mxu=[m(q(h[k])) for k in ['standard_activity_u','standard_mass_u','sample_mass_u']]
activity=a*ms/mx*rmu[0]/rmu[1];relative=(au/a)**2+(msu/ms)**2+(mxu/mx)**2+rcov[0][0]/rmu[0]**2+rcov[1][1]/rmu[1]**2-2*rcov[0][1]/(rmu[0]*rmu[1])
activity2=a*ms/mx*rmean[0];relative2=(au/a)**2+(msu/ms)**2+(mxu/mx)**2+ratio_cov[0][0]/rmean[0]**2
h4={'rates':rates,'rate_means':rmu,'rate_covariance':rcov,'ratio_mean':rmean[0],'ratio_variance':ratio_cov[0][0],'approach1':{'estimate':activity,'variance':activity**2*relative,'u':activity*mp.sqrt(relative)},'approach2':{'estimate':activity2,'variance':activity2**2*relative2,'u':activity2*mp.sqrt(relative2)}}

h=data['h5'];means=list(map(q,h['group_means_V']));sds=[q(v)/10**6 for v in h['group_sample_sds_microV']];j=len(means);k=h['observations_per_group'];grand=sum(means)/j
mean_var=sum((v-grand)**2 for v in means)/(j-1);within=sum(v*v for v in sds)/j;between=(k*mean_var-within)/k
pooled=((j-1)*k*mean_var+j*(k-1)*within)/(j*k-1)
h5={'mean':grand,'within':within,'group_mean_variance':mean_var,'between_component':between,'F':k*mean_var/within,'random_group_variance':mean_var/j,'no_group_variance':pooled/(j*k)}
h5['rounded_intermediate_F']=k*q(h['rounded_group_mean_sd_microV'])**2/q(h['rounded_pooled_within_sd_microV'])**2


h=data['h6'];depth=q(h['mean_depth_scale_units']);sd=q(h['pooled_sd_scale_units']);resolution=q(h['resolution_scale_units']);standard=q(h['standard_average_sd_scale_units']);calibration=q(h['calibration_average_sd_scale_units']);variation=q(h['fractional_variation']);national=q(h['national_definition_u_scale_units'])
parts=[sd**2/5+resolution**2/12,standard**2/h['standard_series_count']+calibration**2/h['calibration_series_count'],(variation*depth)**2/24,national**2];total=sum(parts)
h6={'estimate':100-depth,'component_variances':parts,'variance':total,'u':mp.sqrt(m(total)),'u_mm':mp.sqrt(m(total))*m(q(h['unit_mm']))}

# Independent centered Gaussian moments via the explicit latent transform
# X=Z1,Y=(3Z1+4Z2)/5, with independent standard-normal Z1,Z2.
def add(a,b):
    r=a.copy()
    for e,c in b.items():r[e]=r.get(e,F(0))+c
    return {e:c for e,c in r.items() if c}
def mul(a,b):
    r={}
    for e,c in a.items():
        for f,d in b.items():
            powers=tuple(x+y for x,y in zip(e,f));r[powers]=r.get(powers,F(0))+c*d
    return r
def moment(power):
    return F(0) if power%2 else F(prod(range(1,power,2)))
def expectation(poly,max_degree):
    return sum((c*prod(moment(k) for k in powers) for powers,c in poly.items() if sum(powers)<=max_degree),F(0))
def derivative(poly,i):
    r={}
    for e,c in poly.items():
        if e[i]:
            f=list(e);f[i]-=1;r[tuple(f)]=c*e[i]
    return r
def evaluate0(poly):return poly.get((0,0),F(0))
def latent(poly):
    x={(1,0):F(1)};y={(1,0):F(3,5),(0,1):F(4,5)};out={}
    for powers,c in poly.items():
        term={(0,0):c}
        for expression,power in zip([x,y],powers):
            for _ in range(power):term=mul(term,expression)
        out=add(out,term)
    return out
polys=[{'id':'product','poly':{(1,1):F(1)}},{'id':'cross_third','poly':{(1,0):F(1),(1,2):F(1)}}]
gaussian=[]
for entry in polys:
    poly=entry['poly'];latent_poly=latent(poly);mean=expectation(latent_poly,2);variance=expectation(mul(latent_poly,latent_poly),4)-mean**2
    gaussian.append({'id':entry['id'],'estimate':'0','covariance':[['1','3/5'],['3/5','1']],
        'gradient':[evaluate0(derivative(poly,i)) for i in range(2)],
        'hessian':[[evaluate0(derivative(derivative(poly,i),j)) for j in range(2)] for i in range(2)],
        'third':[[[evaluate0(derivative(derivative(derivative(poly,i),j),k)) for k in range(2)] for j in range(2)] for i in range(2)],
        'corrected_mean':mean,'variance_through_covariance_order2':variance})

def serialize(value):
    if isinstance(value,(F,mp.mpf)):return text(value)
    if isinstance(value,list):return [serialize(x) for x in value]
    if isinstance(value,dict):return {k:serialize(v) for k,v in value.items()}
    return value
out={'schema':'gum-annex-H-independent-reference/1','mpmath_version':mp.__version__,'decimal_precision':80,'h2':h2,'h3':h3,'h4':h4,'h5':h5,'h6':h6,'gaussian_covariance':gaussian}
(root/"gum_annex_reference.json").write_text(json.dumps(serialize(out),separators=(",",":"))+"\n")
