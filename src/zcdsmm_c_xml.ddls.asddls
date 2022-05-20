@EndUserText.label: 'XML Consumption'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZCDSMM_C_XML
  as projection on ZCDSMM_I_XML_HIST_HD
{
  key Chave,

      StatusValid,

      FileRaw,
      XmlStr,
      RefXmlStr,
      Credat,
      Aezet,
      Aenam,
      Archive,
      Status,
      Cnpj,
      Pin,
      ActionRequired,
      Divergencias,
      NfWriteDocnum,

      /* Associations */
      _eDoc,
      _Items    : redirected to composition child ZCDSMM_C_XML_IT,
      _Cods     : redirected to composition child ZCDSMM_C_XML_HD_COD,
      _Log      : redirected to ZCDSMM_C_XML_LOG,
      _LogH     : redirected to ZCDSMM_C_XML_LOGH,
      _LastLogH : redirected to ZCDSMM_C_XML_LOGH_LAST,
      _Obs      : redirected to ZCDSMM_C_XML_OBS,
      _ObsH     : redirected to ZCDSMM_C_XML_OBSH,
      _Errors   : redirected to ZCDSMM_C_LOG_ERROS
}
