#ifndef Bound2Dax_DEFINED
#define Bound2Dax_DEFINED

#include <ctime>
#include "Components.h"

class Bound2Dax
   /* This class calculates mass and heat flows through a surface of an axisymmetric 2D object. 
      Mass flux [kg/(s*m^2)] of a given component out of a surface element is expressed as 
	  par0*(m/v-par1*d), where m is component mass [kg], d is component density [kg/m^3] and v 
	  is element volume [m^3] or as par0*exp(-par1/(R*T)), where R is the gas constant 
	  [J/(mol*K)] and T is element temperature [K]. External heat flux [W/m^2] into the object 
	  can be radiative (RAD) or convective (CONV) in nature. Convective heat flux is specified 
	  as cnv*(outT-T), where cnv is convection coefficient and outT is outside temperature. 
	  outT (in the case of convection) or actual flux (in the case of radiation) is specified 
	  to be position dependent. The dependence is a three-segment piecewise linear function 
	  with zero position at the object axis. The position [m] is non-negative. Three external 
	  heat flux description modules are available to specify the fluxes at different periods of 
	  time [s]. The radiation is handled as follows: when absorption mode is set at MAX, all 
	  radiative heat flux is input into one surface or in-depth element that, according to the 
	  Beer’s law, absorbs most energy. When absorption mode is set at RAND, radiative heat is 
	  input into an element selected at random using the Beer’s law fraction of absorbed energy 
	  as a probability distribution. Additional heat fluxes can be defined using the CAPA 
	  module, which represents boundary conditions in the corresponding apparatus. In this 
	  module, the radiative heat flux depends on the position of the boundary surface, 
	  including its angular orientation. This dependence is described through a set of second 
	  order polynomials. The CAPA convective heat flux is described by a time dependent outside 
	  temperature and position dependent convection coefficient. As in the case of the external 
	  heat fluxes, the CAPA boundary conditions are turned on and off at specified times. 
	  Constant background temperature value is added to all outside temperatures describing 
	  convective heat fluxes. This value is also used to compute extra (background) radiative 
	  heat flux onto the object surface. massflow function uses results of volume calculation 
	  stored in the properts buffer of surface element; it should be applied to all surface 
	  elements of the boundary. inp_indpElem function returns false after all radiation is 
	  absorbed. When properts buffer is defined for the radiation absorbing element, heatflow 
	  function uses results of volume calculation stored in that buffer. The mass and heat 
	  flows (including re-radiation) are added up for all surface elements and reported by 
	  report function. A capability to ramp up or down the external heat fluxes by scaling them 
	  with a factor between 0 and 1, which is a linear function of time, has been added to this 
	  class. */
{
public:
	
	Bound2Dax() { zero(); }
	
	bool load(std::istringstream& boundpar,std::string name="DEFAULT");
	
	int massFlux_Num() { return mF_Num; }
	bool extHeat_On() { return ((EhF1_tend>EhF1_tbeg)||(EhF2_tend>EhF2_tbeg)||(EhF3_tend>EhF3_tbeg)||
		                        (CAPA_tend>CAPA_tbeg)); }
	
	void zero_flows() { extern Comps mat;
	                    for(int c=0; c<mat.Ncomps(); c++) { totl_mF[c]=0.0; }
						totl_hF=totl_area=0.0; }
	
	void massflow(Elem* surface,char surf_axis='X',double slope=1.0,bool calc_der=false);
	
	void inp_surfElem(Elem* surface,char surf_axis='X',double slope=1.0,double position=0.0,double height=0.0);
	bool inp_indpElem(Elem* indepth);
	double heatflow(double tme=0.0,bool calc_der=false);
	
	void report(std::ostream& output,bool header=true);

private:
	
	void zero();
	
	std::string id;
	
	int mF_Num;
	int mF_cInd[Consts::MAX_CMP];
	bool mF_expf[Consts::MAX_CMP];
	double mF_par0[Consts::MAX_CMP];
	double mF_par1[Consts::MAX_CMP];
	
	double mF[Consts::MAX_CMP];
	double totl_mF[Consts::MAX_CMP];
	
	Elem* surf;
	double surf_slp, surf_pos, surf_hgt;
	double surf_area, surf_area_r;
	
	Elem* absr;
	bool rand_absr;
	double rand_val;
	double T_back, hF_back;
	double hF_absr, hF_left;
	
	double EhF1_tbeg, EhF1_tend;
	char EhF1_ramp;
	double EhF1_pos[3], EhF1_val[3], EhF1_chg[3];
	double EhF1_coef;
	
	double EhF2_tbeg, EhF2_tend;
	char EhF2_ramp;
	double EhF2_pos[3], EhF2_val[3], EhF2_chg[3];
	double EhF2_coef;
	
	double EhF3_tbeg, EhF3_tend;
	char EhF3_ramp;
	double EhF3_pos[3], EhF3_val[3], EhF3_chg[3];
	double EhF3_coef;
	
	double CAPA_tbeg, CAPA_tend;
	double CAPA_T[4], CAPA_cv[2];
	double CAPA_rsp;
	double CAPA_b[3];
	double CAPA_a1[3], CAPA_a2[3];
	double CAPA_c1[3], CAPA_c2[3];
	
	double totl_area, totl_hF;
};

#endif