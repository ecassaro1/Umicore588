@EndUserText.label: 'Consumption over ZCDSMM_I_CST_PISCOF'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #CONSUMPTION
@Metadata.allowExtensions: true
define root view entity ZCDSMM_C_CST_PISCOF as projection on ZCDSMM_I_CST_PISCOF {
    key CstNota,
    key CstIva
}
