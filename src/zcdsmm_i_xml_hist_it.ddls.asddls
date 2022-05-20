// Items of ZCDSMM_I_XML_HIST_HD

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'XML History Item'
define view entity ZCDSMM_I_XML_HIST_IT
  as select from ztmm_xml_hist_it
  association        to parent ZCDSMM_I_XML_HIST_HD as _Header  on  _Header.Chave = $projection.Chave
  composition [0..*] of ZCDSMM_I_XML_LOG            as _Log
  composition [0..*] of ZCDSMM_I_LOG_ERROS          as _Errors
  composition [0..*] of ZCDSMM_I_XML_OBS            as _Obs
  association [0..1] to ZCDSMM_I_XML_LOG_LAST       as _LastLog on  _LastLog.Chave = $projection.Chave
                                                                and _LastLog.Id    = $projection.Id
  association [0..1] to ZCDSMM_I_EDOC               as _eDoc    on  _eDoc.Accesskey = $projection.Chave
  association [0..1] to ZCDSMM_I_EDOC_IT            as _eDocIt  on  _eDocIt.Chave = $projection.Chave
                                                                and _eDocIt.Id    = $projection.Id
{
  key chave                  as Chave,
  key id                     as Id,
      cast( id as abap.int4) as id_sort,
      status_valid           as StatusValid,
      status                 as Status,

      x_ped                  as XPed,

      //n_item_ped             as NItemPed,
      cast( n_item_ped as abap.int4 ) as NItemPed,

      _Header,
      _Log,
      _Errors,
      _Obs,
      _LastLog,
      _eDoc,
      _eDocIt
}
