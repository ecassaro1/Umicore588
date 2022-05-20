@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view over ZTMM_XML_R_CFOP'
@Metadata.allowExtensions:true
define root view entity ZCDSMM_I_XML_R_CFOP as select from ztmm_xml_r_cfop
{
    key cfop as Cfop,
    key icms_desonerado as IcmsDesonerado,
    key matorg as OrigMaterial,
    key matuse as UtilMaterial,
    key mwskz as CodIva
}
