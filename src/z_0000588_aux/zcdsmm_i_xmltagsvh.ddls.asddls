@AbapCatalog.sqlViewName: 'ZVMMIXMLTAG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search help for  XML Tags'
//@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view ZCDSMM_I_XMLTAGSVH 
  as select from ZCDSGL_DD07T
{
      @ObjectModel.text.element: ['Description']
      @Search.defaultSearchElement: true      
  key DomvalueL as Tag,
      Ddtext    as Description
}
where
      Domname    = 'ZDMM_XML_TAGS'
  and Ddlanguage = $session.system_language
