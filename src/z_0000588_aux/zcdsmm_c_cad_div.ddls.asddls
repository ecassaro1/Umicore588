@EndUserText.label: 'ZCDSMM_I_CAD_DIV Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions:true
define root view entity ZCDSMM_C_CAD_DIV
  as projection on ZCDSMM_I_CAD_DIV
{
  key CodDiv,
      NomeDiv,
      IndBloq,
      IndDivPed,
      IndDivNfe,
      IndDivRec
}
