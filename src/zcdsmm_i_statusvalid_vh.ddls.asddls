@AbapCatalog.sqlViewName: 'ZVMMISTATVAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Indicator Value Help'
//@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view ZCDSMM_I_StatusValid_VH 
as select from ZCDSGL_DD07T
{
      @ObjectModel.text.element: ['Description']
      @Search.defaultSearchElement: true      
  key DomvalueL as StatusValid,
      Ddtext    as Description
}
where
      Domname    = 'ZDO_STATUS_VALID'
  and Ddlanguage = $session.system_language
