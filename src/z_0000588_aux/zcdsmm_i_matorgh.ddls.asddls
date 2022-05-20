@AbapCatalog.sqlViewName: 'ZVMMIMATORG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search help for  Material Origin'
//@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view ZCDSMM_I_MATORGH
  as select from ZCDSGL_DD07T
{
      @ObjectModel.text.element: ['Description']
      @Search.defaultSearchElement: true      
  key DomvalueL as OrigMaterial,
      Ddtext    as Description
}
where
      Domname    = 'J_1BMATORG'
  and Ddlanguage = $session.system_language
