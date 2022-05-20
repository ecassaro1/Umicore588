@AbapCatalog.sqlViewName: 'ZVMMIXMLSTAT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search help for  XML Status'
//@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view ZCDSMM_I_XMLSTATUSVH 
  as select from ZCDSGL_DD07T
{
      @ObjectModel.text.element: ['Description']
      @Search.defaultSearchElement: true      
  key DomvalueL as Status,
      Ddtext    as Description
}
where
      Domname    = 'ZD_XML_STATUS'
  and Ddlanguage = $session.system_language
