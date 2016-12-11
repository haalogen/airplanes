#ifdef __cplusplus
extern "C" {
#endif
#include <mex.h> 
#include <sci_gateway.h>
#include <api_scilab.h>
#include <MALLOC.h>
static int direct_gateway(char *fname,void F(void)) { F();return 0;};
extern Gatefunc grmos_quantize;
extern Gatefunc grmos_set_region_values;
extern Gatefunc grmos_measure_region_areas;
extern Gatefunc grmos_sum_over_regions;
static GenericTable Tab[]={
  {(Myinterfun)sci_gateway,grmos_quantize,"MQuantize"},
  {(Myinterfun)sci_gateway,grmos_set_region_values,"_MGrMosSetRegionValues"},
  {(Myinterfun)sci_gateway,grmos_measure_region_areas,"_MGrMosMeasureRgnAreas"},
  {(Myinterfun)sci_gateway,grmos_sum_over_regions,"_MGrMosSumOverRegions"},
};
 
int C2F(libMorIARTy_cpp)()
{
  Rhs = Max(0, Rhs);
  if (*(Tab[Fin-1].f) != NULL) 
  {
     if(pvApiCtx == NULL)
     {
       pvApiCtx = (StrCtx*)MALLOC(sizeof(StrCtx));
     }
     pvApiCtx->pstName = (char*)Tab[Fin-1].name;
    (*(Tab[Fin-1].f))(Tab[Fin-1].name,Tab[Fin-1].F);
  }
  return 0;
}
#ifdef __cplusplus
}
#endif
