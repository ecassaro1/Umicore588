@EndUserText.label: 'Last log entry of XML_LOG'
@AccessControl.authorizationCheck: #CHECK
define view entity ZCDSMM_C_XML_LOGH_LAST as projection on ZCDSMM_I_XML_LOGH_LAST {
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
