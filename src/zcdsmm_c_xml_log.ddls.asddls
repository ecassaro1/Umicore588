@EndUserText.label: 'LOG_Erros Consumption'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZCDSMM_C_XML_LOG
  as projection on ZCDSMM_I_XML_LOG
{
  key Chave,
  key Id,
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
      _Header,
      _Item
}
