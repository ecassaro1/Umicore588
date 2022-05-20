@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface view of ZTMM_XML_ENDER'
@Metadata.allowExtensions:true
define root view entity ZCDSMM_I_XML_ENDER
  as select from ztmm_xml_ender
{
  key tag   as Tag,
  key valor as Valor
}
