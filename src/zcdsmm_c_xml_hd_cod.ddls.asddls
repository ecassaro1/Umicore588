@EndUserText.label: 'Consumption over ZCDSMM_I_XML_HD_COD'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZCDSMM_C_XML_HD_COD as projection on zcdsmm_i_xml_hd_cod {
    key Chave,
    key CodDiv,
    NomeDiv,
    /* Associations */
    _Header:    redirected to parent ZCDSMM_C_XML
}
