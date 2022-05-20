@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Observations'
define view entity ZCDSMM_I_XML_OBS
  as select from ztmm_xml_obs
  association to parent ZCDSMM_I_XML_HIST_IT as _Item   on  $projection.Chave = _Item.Chave
                                                        and $projection.Id    = _Item.Id
  association to ZCDSMM_I_XML_HIST_HD        as _Header on  $projection.Chave = _Header.Chave

{
  key chave   as Chave,
  key id      as Id,
  key aedat   as Aedat,
  key aezet   as Aezet,
      aenam   as Aenam,
      message as Message,

      _Item,
      _Header
}
