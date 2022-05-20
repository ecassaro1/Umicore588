@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view over ZTMM_CAD_DIV'
@Metadata.allowExtensions:true
define root view entity ZCDSMM_I_CAD_DIV
  as select from ztmm_cad_div
{
  key cod_div     as CodDiv,
      nome_div    as NomeDiv,
      ind_bloq    as IndBloq,
      ind_div_ped as IndDivPed,
      ind_div_nfe as IndDivNfe,
      ind_div_rec as IndDivRec
}
