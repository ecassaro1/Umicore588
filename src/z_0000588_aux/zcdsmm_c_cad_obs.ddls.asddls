@EndUserText.label: 'Consumption over ZCDSMM_I_CAD_OBS'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #CONSUMPTION
@Metadata.allowExtensions: true
define root view entity ZCDSMM_C_CAD_OBS as projection on ZCDSMM_I_CAD_OBS {
      @Consumption.valueHelpDefinition: [
               { entity.name: 'ZCDSMM_I_XMLSTATUSVH',
                 entity.element: 'Status' }
                 ]
    key Status,
    key Seq,
    TxtNote
}
