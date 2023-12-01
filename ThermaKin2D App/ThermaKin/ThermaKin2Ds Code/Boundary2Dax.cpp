#include "Boundary2Dax.h"

void Bound2Dax::zero()
{
	id="---";
	mF_Num=0;
	
	for(int c=0; c<Consts::MAX_CMP; c++)
	{
		mF_cInd[c]=-1;
		mF_expf[c]=false;
		mF_par0[c]=mF_par1[c]=0.0;
		
		mF[c]=totl_mF[c]=0.0;
	}
	
	surf=absr=NULL;
	surf_slp=surf_pos=surf_hgt=surf_area=surf_area_r=0.0;
	rand_absr=false;
	T_back=hF_back=hF_absr=hF_left=0.0;
	
	EhF1_tbeg=EhF1_tend=EhF2_tbeg=EhF2_tend=EhF3_tbeg=EhF3_tend=0.0;
	EhF1_ramp=EhF2_ramp=EhF3_ramp='H';
	EhF1_coef=EhF2_coef=EhF3_coef=0.0;
	
	CAPA_tbeg=CAPA_tend=0.0;
	CAPA_T[0]=CAPA_T[1]=CAPA_T[2]=CAPA_T[3]=0.0;
	CAPA_cv[0]=CAPA_cv[1]=0.0;
	CAPA_rsp=0.0;
	
	for(int i=0; i<3; i++)
	{
		EhF1_pos[i]=EhF1_val[i]=EhF1_chg[i]=0.0;
		EhF2_pos[i]=EhF2_val[i]=EhF2_chg[i]=0.0;
		EhF3_pos[i]=EhF3_val[i]=EhF3_chg[i]=0.0;
		
		CAPA_b[i]=0.0;
		CAPA_a1[i]=CAPA_a2[i]=0.0;
		CAPA_c1[i]=CAPA_c2[i]=0.0;
	}
	
	totl_area=totl_hF=0.0;
}

bool Bound2Dax::load(std::istringstream& boundpar,std::string name)
{
	zero();
	id=name;
	
	std::string buf;
	if(!((boundpar>>buf)&&(buf=="MASS")&&(boundpar>>buf)&&(buf=="TRANSPORT:")&&
		(boundpar>>buf))) { return false; }
	
	extern Comps mat;
	if(buf=="YES")
	{
		if(!(boundpar>>buf)) { return false; }
		do
		{
			if(mF_Num>=Consts::MAX_CMP) { return false; }
			
			mF_cInd[mF_Num]=mat.comp_indx(buf);
			
			if(boundpar>>buf) { if(buf=="EXP") { mF_expf[mF_Num]=true; } }
			else { return false; }
			
			if(!((boundpar>>mF_par0[mF_Num])&&(boundpar>>mF_par1[mF_Num])&&
				 (boundpar>>buf))) { return false; }
			
			if(mF_cInd[mF_Num]>=0) { ++mF_Num; }
		} while(buf!="EXTERNAL");
	}
	else
	{
		do { if(!(boundpar>>buf)) { return false; } } while(buf!="EXTERNAL");
	}
	
	if(!((boundpar>>buf)&&(buf=="HEAT")&&(boundpar>>buf)&&(buf=="FLUX")&&(boundpar>>buf)&&
		 (buf=="1:")&&(boundpar>>buf))) { return false; }
	
	if(buf=="YES")
	{
		if(!((boundpar>>buf)&&(buf=="START")&&(boundpar>>buf)&&(buf=="&")&&(boundpar>>buf)&&
			 (buf=="END")&&(boundpar>>buf)&&(buf=="TIMES:")&&(boundpar>>EhF1_tbeg)&&
			 (boundpar>>EhF1_tend)&&(boundpar>>buf)&&(buf=="RAMP:")&&(boundpar>>buf)))
		     { return false; }
		
		if(buf=="UP") { EhF1_ramp='U'; } else if (buf=="DOWN") { EhF1_ramp='D'; }
		
		if(!((boundpar>>buf)&&(buf=="MODE:")&&(boundpar>>buf))) { return false; }
		
		if(buf=="CONV")
		{
			if(!((boundpar>>buf)&&(buf=="CONVECTION")&&(boundpar>>buf)&&(buf=="COEFF:")&&
				 (boundpar>>EhF1_coef))) { return false; }
		}
		
		if(!((boundpar>>buf)&&(buf=="POSITION")&&(boundpar>>buf)&&(buf=="DEPEND1:")&&
			 (boundpar>>EhF1_val[0])&&(boundpar>>EhF1_chg[0])&&(boundpar>>EhF1_pos[0])&&
			 (boundpar>>buf)&&(buf=="POSITION")&&(boundpar>>buf)&&(buf=="DEPEND2:")&&
			 (boundpar>>EhF1_val[1])&&(boundpar>>EhF1_chg[1])&&(boundpar>>EhF1_pos[1])&&
			 (boundpar>>buf)&&(buf=="POSITION")&&(boundpar>>buf)&&(buf=="DEPEND3:")&&
			 (boundpar>>EhF1_val[2])&&(boundpar>>EhF1_chg[2])&&(boundpar>>EhF1_pos[2])&&
			 (boundpar>>buf)&&(buf=="EXTERNAL"))) { return false; }
	}
	else
	{
		do { if(!(boundpar>>buf)) { return false; } } while(buf!="EXTERNAL");
	}
	
	if(!((boundpar>>buf)&&(buf=="HEAT")&&(boundpar>>buf)&&(buf=="FLUX")&&(boundpar>>buf)&&
		 (buf=="2:")&&(boundpar>>buf))) { return false; }
	
	if(buf=="YES")
	{
		if(!((boundpar>>buf)&&(buf=="START")&&(boundpar>>buf)&&(buf=="&")&&(boundpar>>buf)&&
			 (buf=="END")&&(boundpar>>buf)&&(buf=="TIMES:")&&(boundpar>>EhF2_tbeg)&&
			 (boundpar>>EhF2_tend)&&(boundpar>>buf)&&(buf=="RAMP:")&&(boundpar>>buf)))
		     { return false; }
		
		if(buf=="UP") { EhF2_ramp='U'; } else if (buf=="DOWN") { EhF2_ramp='D'; }
		
		if(!((boundpar>>buf)&&(buf=="MODE:")&&(boundpar>>buf))) { return false; }
		
		if(buf=="CONV")
		{
			if(!((boundpar>>buf)&&(buf=="CONVECTION")&&(boundpar>>buf)&&(buf=="COEFF:")&&
				 (boundpar>>EhF2_coef))) { return false; }
		}
		
		if(!((boundpar>>buf)&&(buf=="POSITION")&&(boundpar>>buf)&&(buf=="DEPEND1:")&&
			 (boundpar>>EhF2_val[0])&&(boundpar>>EhF2_chg[0])&&(boundpar>>EhF2_pos[0])&&
			 (boundpar>>buf)&&(buf=="POSITION")&&(boundpar>>buf)&&(buf=="DEPEND2:")&&
			 (boundpar>>EhF2_val[1])&&(boundpar>>EhF2_chg[1])&&(boundpar>>EhF2_pos[1])&&
			 (boundpar>>buf)&&(buf=="POSITION")&&(boundpar>>buf)&&(buf=="DEPEND3:")&&
			 (boundpar>>EhF2_val[2])&&(boundpar>>EhF2_chg[2])&&(boundpar>>EhF2_pos[2])&&
			 (boundpar>>buf)&&(buf=="EXTERNAL"))) { return false; }
	}
	else
	{
		do { if(!(boundpar>>buf)) { return false; } } while(buf!="EXTERNAL");
	}
	
	if(!((boundpar>>buf)&&(buf=="HEAT")&&(boundpar>>buf)&&(buf=="FLUX")&&(boundpar>>buf)&&
		 (buf=="3:")&&(boundpar>>buf))) { return false; }
	
	if(buf=="YES")
	{
		if(!((boundpar>>buf)&&(buf=="START")&&(boundpar>>buf)&&(buf=="&")&&(boundpar>>buf)&&
			 (buf=="END")&&(boundpar>>buf)&&(buf=="TIMES:")&&(boundpar>>EhF3_tbeg)&&
			 (boundpar>>EhF3_tend)&&(boundpar>>buf)&&(buf=="RAMP:")&&(boundpar>>buf)))
		     { return false; }
		
		if(buf=="UP") { EhF3_ramp='U'; } else if (buf=="DOWN") { EhF3_ramp='D'; }
		
		if(!((boundpar>>buf)&&(buf=="MODE:")&&(boundpar>>buf))) { return false; }
		
		if(buf=="CONV")
		{
			if(!((boundpar>>buf)&&(buf=="CONVECTION")&&(boundpar>>buf)&&(buf=="COEFF:")&&
				 (boundpar>>EhF3_coef))) { return false; }
		}
		
		if(!((boundpar>>buf)&&(buf=="POSITION")&&(boundpar>>buf)&&(buf=="DEPEND1:")&&
			 (boundpar>>EhF3_val[0])&&(boundpar>>EhF3_chg[0])&&(boundpar>>EhF3_pos[0])&&
			 (boundpar>>buf)&&(buf=="POSITION")&&(boundpar>>buf)&&(buf=="DEPEND2:")&&
			 (boundpar>>EhF3_val[1])&&(boundpar>>EhF3_chg[1])&&(boundpar>>EhF3_pos[1])&&
			 (boundpar>>buf)&&(buf=="POSITION")&&(boundpar>>buf)&&(buf=="DEPEND3:")&&
			 (boundpar>>EhF3_val[2])&&(boundpar>>EhF3_chg[2])&&(boundpar>>EhF3_pos[2])&&
			 (boundpar>>buf)&&(buf=="CAPA"))) { return false; }
	}
	else
	{
		do { if(!(boundpar>>buf)) { return false; } } while(buf!="CAPA");
	}
	
	if(!((boundpar>>buf)&&(buf=="HEAT")&&(boundpar>>buf)&&(buf=="FLUX:")&&(boundpar>>buf)))
	{ return false;	}
	
	if(buf=="YES")
	{
		if(!((boundpar>>buf)&&(buf=="START")&&(boundpar>>buf)&&(buf=="&")&&(boundpar>>buf)&&
			 (buf=="END")&&(boundpar>>buf)&&(buf=="TIMES:")&&(boundpar>>CAPA_tbeg)&&
			 (boundpar>>CAPA_tend)&&(boundpar>>buf)&&(buf=="OUTSIDE")&&(boundpar>>buf)&&
			 (buf=="TEMP")&&(boundpar>>buf)&&(buf=="HIST:")&&(boundpar>>CAPA_T[0])&&
			 (boundpar>>CAPA_T[1])&&(boundpar>>CAPA_T[2])&&(boundpar>>CAPA_T[3])&&
			 (boundpar>>buf)&&(buf=="CONV")&&(boundpar>>buf)&&(buf=="COEFF")&&(boundpar>>buf)&&
			 (buf=="POS")&&(boundpar>>buf)&&(buf=="DEPEND:")&&(boundpar>>CAPA_cv[0])&&
			 (boundpar>>CAPA_cv[1])&&(boundpar>>buf)&&(buf=="RADIATION")&&(boundpar>>buf)&&
			 (buf=="SETPOINT:")&&(boundpar>>CAPA_rsp)&&(boundpar>>buf)&&(buf=="VERT")&&
			 (boundpar>>buf)&&(buf=="RAD")&&(boundpar>>buf)&&(buf=="DEPEND:")&&
			 (boundpar>>CAPA_b[0])&&(boundpar>>CAPA_b[1])&&(boundpar>>CAPA_b[2])&&
			 (boundpar>>buf)&&(buf=="RADIAL")&&(boundpar>>buf)&&(buf=="RAD")&&(boundpar>>buf)&&
			 (buf=="DEPEND:")&&(boundpar>>CAPA_a1[0])&&(boundpar>>CAPA_a1[1])&&
			 (boundpar>>CAPA_a1[2])&&(boundpar>>CAPA_a2[0])&&(boundpar>>CAPA_a2[1])&&
			 (boundpar>>CAPA_a2[2])&&(boundpar>>buf)&&(buf=="ANGUL")&&(boundpar>>buf)&&
			 (buf=="RAD")&&(boundpar>>buf)&&(buf=="DEPEND:")&&(boundpar>>CAPA_c1[0])&&
			 (boundpar>>CAPA_c1[1])&&(boundpar>>CAPA_c1[2])&&(boundpar>>CAPA_c2[0])&&
			 (boundpar>>CAPA_c2[1])&&(boundpar>>CAPA_c2[2])&&(boundpar>>buf)&&
			 (buf=="BACKGROUND"))) { return false; }
	}
	else
	{
		do { if(!(boundpar>>buf)) { return false; } } while(buf!="BACKGROUND");
	}
	
	if(!((boundpar>>buf)&&(buf=="TEMP:")&&(boundpar>>T_back)&&(boundpar>>buf)&&
		 (buf=="RADIAT")&&(boundpar>>buf)&&(buf=="ABSORPT")&&(boundpar>>buf)&&
		 (buf=="MODE:")&&(boundpar>>buf))) { return false; }
	
	hF_back=Consts::SIGMA*pow(T_back,4);
	if(buf=="RAND") { rand_absr=true; srand((unsigned)time(NULL)); }
	
	return true;
}

void Bound2Dax::massflow(Elem* surface,char surf_axis,double slope,bool calc_der)
{
	switch(surf_axis)
	{
		case 'X': surf_area=surface->Ydim*surface->Zdim*slope; break;
		case 'Y': surf_area=surface->Xdim*surface->Zdim*slope; break;
		case 'Z': surf_area=surface->Xdim*surface->Ydim*slope; break;
		default: surf_area=1.0;
	}
	totl_area+=surf_area;
	
	extern Comps mat;
	for(int F=0; F<mF_Num; F++)
	{
		if(mF_expf[F])
		{
			double totl_mass=0.0;
			for(int c=0; c<mat.Ncomps(); c++) { totl_mass+=surface->massT[c]; }
			if((surface->massT[mF_cInd[F]]/totl_mass)>0.5)
			{
				mF[F]=mF_par0[F]*exp(-mF_par1[F]/(Consts::R*surface->massT[mat.Ncomps()]));
			}
			else { mF[F]=0.0; }
		}
		else
		{
			mF[F]=mF_par0[F]*(surface->massT[mF_cInd[F]]/surface->properts->vol-mF_par1[F]/
				              surface->properts->one_vs_dns[mF_cInd[F]]);
		}
		
		mF[F]*=surf_area;
		surface->massT_rate[mF_cInd[F]].rt0-=mF[F];
		totl_mF[mF_cInd[F]]+=mF[F];
	}
	
	if(calc_der)
	{
		for(int F=0; F<mF_Num; F++)
		{
			if(mF_expf[F])
			{
				surface->massT_rate[mF_cInd[F]].thisElem[mat.Ncomps()]-=mF[F]*mF_par1[F]/
					                                            (Consts::R*
																 surface->massT[mat.Ncomps()]*
																 surface->massT[mat.Ncomps()]);
			}
			else
			{
				double par0_area=mF_par0[F]*surf_area;
				double m_vs_vol2=surface->massT[mF_cInd[F]]/surface->properts->vol/
					                                        surface->properts->vol;
				
				for(int c=0; c<mat.Ncomps(); c++)
				{
					if(mF_cInd[F]==c)
					{
						surface->massT_rate[mF_cInd[F]].thisElem[c]-=par0_area*
							                             (1.0/surface->properts->vol-m_vs_vol2*
														  surface->properts->d_vol_dm[c]);
					}
					else
					{
						surface->massT_rate[mF_cInd[F]].thisElem[c]+=par0_area*m_vs_vol2*
							                                    surface->properts->d_vol_dm[c];
					}
				}
				surface->massT_rate[mF_cInd[F]].thisElem[mat.Ncomps()]+=par0_area*
					            (m_vs_vol2*surface->properts->d_vol_dT+mF_par1[F]*
								 mat.d_comp_dens_dT(mF_cInd[F],surface->massT[mat.Ncomps()]));
			}
		}
	}
}

void Bound2Dax::inp_surfElem(Elem* surface,char surf_axis,double slope,double position,double height)
{
	surf=surface; absr=surface;
	
	surf_slp=slope; surf_pos=position; surf_hgt=height;
	
	switch(surf_axis)
	{
		case 'X': surf_area_r=surf->Ydim*surf->Zdim; break;
		case 'Y': surf_area_r=surf->Xdim*surf->Zdim; break;
		case 'Z': surf_area_r=surf->Xdim*surf->Ydim; break;
		default: surf_area_r=1.0;
	}
	surf_area=surf_area_r*surf_slp;
	
	extern Comps mat;
	hF_absr=mat.absorption(*absr)/surf_area_r;
	if(rand_absr)
	{
		rand_val=rand()/(RAND_MAX+1.0);
		hF_left=((hF_absr>=rand_val) ? 0.0 : 1.0);
	}
	else { hF_left=1.0-hF_absr; }
}

bool Bound2Dax::inp_indpElem(Elem* indepth)
{
	if(hF_left>1.0e-3)
	{
		extern Comps mat;
		if(rand_absr)
		{
			hF_absr+=(1.0-hF_absr)*mat.absorption(*indepth)/surf_area_r;
			if(hF_absr>=rand_val) { absr=indepth; hF_left=0.0; }
		}
		else
		{
			double n_hF_absr=hF_left*mat.absorption(*indepth)/surf_area_r;
			if((n_hF_absr>=hF_absr)&&(hF_left>=hF_absr))
			{
				absr=indepth; hF_absr=n_hF_absr;
			}
			hF_left-=n_hF_absr;
		}
		
		return true;
	}
	else { return false; }
}

double Bound2Dax::heatflow(double tme,bool calc_der)
{
	double totl_hF_old=totl_hF;
	
	extern Comps mat;
	if(absr->properts) { mat.import_buf(*absr); }
	else { mat.volume(*absr); }
	double emis_area=mat.emissivity()*surf_area;
	if(hF_left>1.0e-3) { emis_area*=1.0-hF_left; }
	
	double heat=emis_area*Consts::SIGMA*pow(absr->massT[mat.Ncomps()],4);
	if(calc_der)
	{
		absr->massT_rate[mat.Ncomps()].thisElem[mat.Ncomps()]-=4.0*heat/absr->massT[mat.Ncomps()];
	}
	heat-=emis_area*hF_back;
	absr->massT_rate[mat.Ncomps()].rt0-=heat;
	totl_hF-=heat;
	
	if((tme>=EhF1_tbeg)&&(tme<EhF1_tend))
	{
		bool yesheat=true;
		if(surf_pos<EhF1_pos[0]) { heat=EhF1_val[0]+EhF1_chg[0]*surf_pos; }
		else if(surf_pos<EhF1_pos[1]) { heat=EhF1_val[1]+EhF1_chg[1]*surf_pos; }
		else if(surf_pos<EhF1_pos[2]) { heat=EhF1_val[2]+EhF1_chg[2]*surf_pos; }
		else { yesheat=false; }
		
		if(yesheat)
		{
			if(EhF1_coef!=0.0)
			{
				heat+=T_back;
				heat-=surf->massT[mat.Ncomps()];
				double coef_area=EhF1_coef*surf_area;
				if(EhF1_ramp=='U') { coef_area*=(tme-EhF1_tbeg)/(EhF1_tend-EhF1_tbeg); }
				else if(EhF1_ramp=='D') { coef_area*=(EhF1_tend-tme)/(EhF1_tend-EhF1_tbeg); }
				heat*=coef_area;
				
				surf->massT_rate[mat.Ncomps()].rt0+=heat;
				if(calc_der) { surf->massT_rate[mat.Ncomps()].thisElem[mat.Ncomps()]-=coef_area; }
				totl_hF+=heat;
			}
			else
			{
				heat*=emis_area;
				if(EhF1_ramp=='U') { heat*=(tme-EhF1_tbeg)/(EhF1_tend-EhF1_tbeg); }
				else if(EhF1_ramp=='D') { heat*=(EhF1_tend-tme)/(EhF1_tend-EhF1_tbeg); }
				absr->massT_rate[mat.Ncomps()].rt0+=heat;
				totl_hF+=heat;
			}
		}
	}
	
	if((tme>=EhF2_tbeg)&&(tme<EhF2_tend))
	{
		bool yesheat=true;
		if(surf_pos<EhF2_pos[0]) { heat=EhF2_val[0]+EhF2_chg[0]*surf_pos; }
		else if(surf_pos<EhF2_pos[1]) { heat=EhF2_val[1]+EhF2_chg[1]*surf_pos; }
		else if(surf_pos<EhF2_pos[2]) { heat=EhF2_val[2]+EhF2_chg[2]*surf_pos; }
		else { yesheat=false; }
		
		if(yesheat)
		{
			if(EhF2_coef!=0.0)
			{
				heat+=T_back;
				heat-=surf->massT[mat.Ncomps()];
				double coef_area=EhF2_coef*surf_area;
				if(EhF2_ramp=='U') { coef_area*=(tme-EhF2_tbeg)/(EhF2_tend-EhF2_tbeg); }
				else if(EhF2_ramp=='D') { coef_area*=(EhF2_tend-tme)/(EhF2_tend-EhF2_tbeg); }
				heat*=coef_area;
				
				surf->massT_rate[mat.Ncomps()].rt0+=heat;
				if(calc_der) { surf->massT_rate[mat.Ncomps()].thisElem[mat.Ncomps()]-=coef_area; }
				totl_hF+=heat;
			}
			else
			{
				heat*=emis_area;
				if(EhF2_ramp=='U') { heat*=(tme-EhF2_tbeg)/(EhF2_tend-EhF2_tbeg); }
				else if(EhF2_ramp=='D') { heat*=(EhF2_tend-tme)/(EhF2_tend-EhF2_tbeg); }
				absr->massT_rate[mat.Ncomps()].rt0+=heat;
				totl_hF+=heat;
			}
		}
	}
	
	if((tme>=EhF3_tbeg)&&(tme<EhF3_tend))
	{
		bool yesheat=true;
		if(surf_pos<EhF3_pos[0]) { heat=EhF3_val[0]+EhF3_chg[0]*surf_pos; }
		else if(surf_pos<EhF3_pos[1]) { heat=EhF3_val[1]+EhF3_chg[1]*surf_pos; }
		else if(surf_pos<EhF3_pos[2]) { heat=EhF3_val[2]+EhF3_chg[2]*surf_pos; }
		else { yesheat=false; }
		
		if(yesheat)
		{
			if(EhF3_coef!=0.0)
			{
				heat+=T_back;
				heat-=surf->massT[mat.Ncomps()];
				double coef_area=EhF3_coef*surf_area;
				if(EhF3_ramp=='U') { coef_area*=(tme-EhF3_tbeg)/(EhF3_tend-EhF3_tbeg); }
				else if(EhF3_ramp=='D') { coef_area*=(EhF3_tend-tme)/(EhF3_tend-EhF3_tbeg); }
				heat*=coef_area;
				
				surf->massT_rate[mat.Ncomps()].rt0+=heat;
				if(calc_der) { surf->massT_rate[mat.Ncomps()].thisElem[mat.Ncomps()]-=coef_area; }
				totl_hF+=heat;
			}
			else
			{
				heat*=emis_area;
				if(EhF3_ramp=='U') { heat*=(tme-EhF3_tbeg)/(EhF3_tend-EhF3_tbeg); }
				else if(EhF3_ramp=='D') { heat*=(EhF3_tend-tme)/(EhF3_tend-EhF3_tbeg); }
				absr->massT_rate[mat.Ncomps()].rt0+=heat;
				totl_hF+=heat;
			}
		}
	}
	
	if((tme>=CAPA_tbeg)&&(tme<CAPA_tend))
	{
		heat=CAPA_T[0]*exp(CAPA_T[1]*tme)+CAPA_T[2]*exp(CAPA_T[3]*tme)+T_back;
		heat-=surf->massT[mat.Ncomps()];
		double coef_area=(CAPA_cv[0]+CAPA_cv[1]*surf_pos)*surf_area;
		heat*=coef_area;
		
		surf->massT_rate[mat.Ncomps()].rt0+=heat;
		if(calc_der) { surf->massT_rate[mat.Ncomps()].thisElem[mat.Ncomps()]-=coef_area; }
		totl_hF+=heat;
		
		heat=CAPA_rsp*emis_area;
		surf_hgt-=CAPA_b[0];
		if (surf_hgt<0.0) { surf_hgt=0.0; }
		
		heat*=1.0+(CAPA_b[1]+CAPA_b[2]*surf_hgt)*surf_hgt;
		heat*=1.0+(CAPA_a1[0]+(CAPA_a1[1]+CAPA_a1[2]*surf_hgt)*surf_hgt+
			       (CAPA_a2[0]+(CAPA_a2[1]+CAPA_a2[2]*surf_hgt)*surf_hgt)*surf_pos)*surf_pos;
		double surf_ang=acos(1.0/surf_slp);
		heat*=1.0+(CAPA_c1[0]+(CAPA_c1[1]+CAPA_c1[2]*surf_hgt)*surf_hgt+
			       (CAPA_c2[0]+(CAPA_c2[1]+CAPA_c2[2]*surf_hgt)*surf_hgt)*surf_ang)*surf_ang;
		
		absr->massT_rate[mat.Ncomps()].rt0+=heat;
		totl_hF+=heat;
	}
	
	return ((totl_hF-totl_hF_old)/surf_area);
}

void Bound2Dax::report(std::ostream& output,bool header)
{
	extern Comps mat;
	if(header)
	{
		output<<"BOUNDARY\tAREA [m^2]   \tHEAT FLOW IN [W]\tMASS FLOW OUT [kg/s]:";
		for(int c=0; c<mat.Ncomps(); c++) { output<<"\t"<<mat.comp_name(c); }
		output<<"\n";
	}
	
	if(fabs(totl_hF)<1.0e-12) { totl_hF=0.0; }
	
	output<<id<<"\t"<<(totl_area*6.28318530718)<<"\t"<<(totl_hF*6.28318530718)<<"\t";
	for(int c=0; c<mat.Ncomps(); c++) { output<<"\t"<<(totl_mF[c]*6.28318530718); }
	output<<"\n";
}