@AbapCatalog.sqlViewName: 'ZVMMIPIN'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pin Value Help'
@Search.searchable: true
define view ZCDSMM_I_PIN_VH 
as select from ZCDSGL_DD07T
{
      @ObjectModel.text.element: ['Description']
      @Search.defaultSearchElement: true      
  key DomvalueL as Pin,
      Ddtext    as Description
}
where
      Domname    = 'ZNFEPIN'
  and Ddlanguage = $session.system_language
