@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view over ZCDSMM_C_XML_R_CFOP'
@Metadata.allowExtensions:true
define root view entity ZCDSMM_C_XML_R_CFOP as projection on ZCDSMM_I_XML_R_CFOP 
{
    key Cfop,
    key IcmsDesonerado,
      @Consumption.valueHelpDefinition: [
               { entity.name: 'ZCDSMM_I_MATORGH',
                 entity.element: 'OrigMaterial' }
                 ]        
    key OrigMaterial,
      @Consumption.valueHelpDefinition: [
               { entity.name: 'ZCDSMM_I_MATUSEVH',
                 entity.element: 'UtilMaterial' }
                 ]            
    key UtilMaterial,
          @Consumption.valueHelpDefinition: [
               { entity.name: 'ZCDSMM_I_MWSKZVH',
                 entity.element: 'CodIva' }
                 ]
    key CodIva
}
