"""Build explicit MCM profiles from pinned factual inputs and independent moments."""
from pathlib import Path
from fractions import Fraction as F
import json
import mpmath as mp
mp.mp.dps=80
root=Path(__file__).resolve().parents[1]/"fixtures"/"evaluation"
inputs=json.loads((root/"gum5_inputs.json").read_text());refs=json.loads((root/"gum5_reference.json").read_text());bro=json.loads((root/"gum6_bromine.json").read_text())
text=lambda x:mp.nstr(x,75)
number=lambda x:mp.mpf(F(x).numerator)/F(x).denominator
seeds=[12345,23456,34567,45678]
cases=[]
def add(id,model,pdfs,mean,u,source,**extra):
    cases.append(dict(id=id,model=model,inputs=pdfs,seeds=seeds,source_pdf_sha256=source,expected_mean=str(mean),expected_standard_uncertainty=str(u),**extra))
for index,(dist,sds) in enumerate(zip(inputs["linear_sum"]["distributions"],inputs["linear_sum"]["standard_uncertainties"])):
    pdfs={}
    for name,sd in zip('abcd',sds):
        if dist=='normal':pdfs[name]=dict(distribution=dist,location='0',sd=sd)
        else:
            half=mp.sqrt(3)*number(sd)
            pdfs[name]=dict(distribution=dist,lower=text(-half),upper=text(half))
    add('gum5_linear_'+str(index+1),'a+b+c+d',pdfs,'0',text(mp.sqrt(number(refs['linear_sum'][index]['variance']))),inputs['source']['sha256'],unit='dimensionless')
for index,vector in enumerate(refs['comparison_loss']):
    v=F(inputs['comparison_loss']['standard_uncertainty'])**2;rho=F(vector['correlation'])
    pdfs=dict(x=dict(distribution='normal',location=vector['x1'],sd='0.005'),y=dict(distribution='normal',location='0',sd='0.005'))
    add('gum5_comparison_loss_'+str(index+1),'x^2+y^2',pdfs,vector['mean'],text(mp.sqrt(number(vector['variance']))),inputs['source']['sha256'],unit='dimensionless',independent=False,joint_distribution='multivariate_normal',joint_covariance=[[str(v),str(rho*v)],[str(rho*v),str(v)]])
mass=inputs['mass_calibration'];pdfs={name:dict(distribution='normal',location=mu,sd=sd) for name,mu,sd in zip('pq',mass['mass_means_mg'],mass['mass_standard_uncertainties_mg'])}
for name,center,half in zip('awr',mass['density_means_kg_m3'],mass['density_half_widths_kg_m3']):
    center,half=F(center),F(half);pdfs[name]=dict(distribution='rectangular',lower=str(center-half),upper=str(center+half))
add('gum5_mass_calibration','(p+q)*(1+(a-1.2)*(1/w-1/r))-100000',pdfs,refs['mass_calibration']['mean'],refs['mass_calibration']['standard_uncertainty'],inputs['source']['sha256'],unit='mg')
add('gum6_bromine',bro['model'],dict(x=dict(distribution='normal',location=bro['estimate'],sd=bro['standard_uncertainty'])),refs['bromine']['mean'],text(mp.sqrt(number(refs['bromine']['variance']))),bro['source']['pdf_sha256'],unit='fraction')
(root/'gum_mcm_profiles.json').write_text(json.dumps(dict(schema='gum-mcm-reference/1',moment_tolerance='two adaptive numerical tolerances, applied to mean and standard uncertainty; no global coverage claim',intervals='both interval kinds must stabilize; population interval validation is separate',cases=cases),indent=2)+'\n')
