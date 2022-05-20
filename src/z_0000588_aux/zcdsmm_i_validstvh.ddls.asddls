@AbapCatalog.sqlViewName: 'ZVMMIVALIDST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search help for  XML Validation Status'
//@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view ZCDSMM_I_VALIDSTVH 
  as select from ZCDSGL_DD07T
{
      @ObjectModel.text.element: ['Description']
      @Search.defaultSearchElement: true      
  key DomvalueL as StatusValid,
      Ddtext    as Description
}
where
      Domname    = 'ZD_XML_STATUS_VALID'
  and Ddlanguage = $session.system_language

