@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view over ZTMM_XML_REGRA'
@Metadata.allowExtensions:true
define root view entity ZCDSMM_I_XML_REGRA as select from ztmm_xml_regra
{
    key tag_xml_hdr as TagXmlHdr,
    key tag_xml_item as TagXmlItem,
    campo_sap as CampoSap,
    status_valid as StatusValid,
    message as Message
}
