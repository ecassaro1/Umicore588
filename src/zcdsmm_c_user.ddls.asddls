@EndUserText.label: 'ZCDSMM_I_USER Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZCDSMM_C_USER
  as projection on ZCDSMM_I_USER
{
  key BName,
      NameText
}
