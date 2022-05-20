@EndUserText.label: 'Consumption over ZCDSMM_I_XML_OBS'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZCDSMM_C_XML_OBS as projection on ZCDSMM_I_XML_OBS {
    key Chave,
    key Id,
    key Aedat,
    key Aezet,
    Aenam,
    Message,
    /* Associations */
    _Header,
    _Item
}
