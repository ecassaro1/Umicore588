@AbapCatalog.sqlViewName: 'ZVMMIACTREQ'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Action Required Value Help'
@Search.searchable: true
define view ZCDSMM_I_ACTIONREQUIRED_VH 
as select from ZCDSGL_DD07T
{
      @ObjectModel.text.element: ['Description']
      @Search.defaultSearchElement: true      
  key DomvalueL as ActionRequired,
      Ddtext    as Description
}
where
      Domname    = 'ZACTION_REQUIRED'
  and Ddlanguage = $session.system_language
