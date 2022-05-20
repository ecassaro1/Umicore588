@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view over ZTMM_CST_PISCOF'
@Metadata.allowExtensions:true
define root view entity ZCDSMM_I_CST_PISCOF as select from ztmm_cst_piscof
{
    key cst_nota as CstNota,
    key cst_iva  as CstIva
}
