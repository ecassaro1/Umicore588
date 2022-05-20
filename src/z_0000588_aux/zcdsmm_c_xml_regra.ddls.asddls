@EndUserText.label: 'Consumption over ZCDSMM_I_XML_REGRA'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #CONSUMPTION
@Metadata.allowExtensions: true
define root view entity ZCDSMM_C_XML_REGRA as projection on ZCDSMM_I_XML_REGRA 
{
    key TagXmlHdr,
    key TagXmlItem,
    CampoSap,
      @Consumption.valueHelpDefinition: [
               { entity.name: 'ZCDSMM_I_VALIDSTVH',
                 entity.element: 'StatusValid' }
                 ]    
    StatusValid,
    Message    
}
