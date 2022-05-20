@EndUserText.label: 'XML Item Consumption'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZCDSMM_C_XML_IT
  as projection on ZCDSMM_I_XML_HIST_IT
{
  key Chave,
  key Id,
      id_sort,
      StatusValid,
      Status,

      XPed,
      NItemPed,

      /* Associations */
      _Header  : redirected to parent ZCDSMM_C_XML,
      _Log     : redirected to ZCDSMM_C_XML_LOG,
      _Errors  : redirected to ZCDSMM_C_LOG_ERROS,
      _Obs     : redirected to ZCDSMM_C_XML_OBS,
      _LastLog : redirected to ZCDSMM_C_XML_LOG_LAST,
      _eDoc    : redirected to ZCDSMM_C_EDOC,
      _eDocIt  : redirected to ZCDSMM_C_EDOC_IT
}
