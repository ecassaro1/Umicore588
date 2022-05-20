@EndUserText.label: 'Consumption over ZCDSMM_I_XML_OBSH'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZCDSMM_C_XML_OBSH as projection on ZCDSMM_I_XML_OBSH {
    key Chave,
    key Aedat,
    key Aezet,
    Aenam,
    Message,
    UserName,
    /* Associations */
    _Header
}
