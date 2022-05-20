@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ZCDSMM_I_XML_ENDER Projection'
@Metadata.allowExtensions:true
define root view entity ZCDSMM_C_XML_ENDER
  as projection on ZCDSMM_I_XML_ENDER
{
      @Consumption.valueHelpDefinition: [
               { entity.name: 'ZCDSMM_I_XMLTAGSVH',
                 entity.element: 'Tag' }
                 ]
  key Tag,
  key Valor
}
