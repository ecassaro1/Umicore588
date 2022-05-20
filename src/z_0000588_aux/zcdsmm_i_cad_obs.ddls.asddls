@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view over ZTMM_CAD_OBS'
@Metadata.allowExtensions:true
define root view entity ZCDSMM_I_CAD_OBS as select from ztmm_cad_obs
{
    key status as Status,
    key seq as Seq,
    txt_note as TxtNote
}
