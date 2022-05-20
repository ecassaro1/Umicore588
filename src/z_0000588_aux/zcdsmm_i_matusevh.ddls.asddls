@AbapCatalog.sqlViewName: 'ZVMMIMATUSE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search help for  Material Usage'
//@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view ZCDSMM_I_MATUSEVH 
  as select from ZCDSGL_DD07T
{
      @ObjectModel.text.element: ['Description']
      @Search.defaultSearchElement: true      
  key DomvalueL as UtilMaterial,
      Ddtext    as Description
}
where
      Domname    = 'J_1BMATUSE'
  and Ddlanguage = $session.system_language
