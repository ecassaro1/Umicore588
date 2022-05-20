@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cancelled statuses'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDSMM_I_EDOCUMENTHISTORY_CANC
  as select from edocumenthistory
{
  edoc_guid as EdocGuid
}
where
     process     = 'BRCANCEL'
//  or proc_status = 'STA_CANC'
group by
  edoc_guid
