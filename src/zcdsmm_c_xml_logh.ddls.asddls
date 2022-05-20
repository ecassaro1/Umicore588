@EndUserText.label: 'LOG_Erros Consumption'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZCDSMM_C_XML_LOGH
  as projection on ZCDSMM_I_XML_LOGH
{
  key Chave,
  key Seq,
      TagXmlHdr,
      TagXmlItem,
      Aedat,
      Aezet,
      Aenam,
      CampoSap,
      StatusValid,
      XPed,
      NItemPed,
      Oldvalue,
      Newvalue,
      TagXmlValor,
      Message,

      /* Associations */
      _Header
}
