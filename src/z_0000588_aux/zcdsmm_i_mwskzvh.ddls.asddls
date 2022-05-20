@AbapCatalog.sqlViewName: 'ZVMMIMWSKZ'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search help for  Tax on sales/purchases code'
//@ObjectModel.resultSet.sizeCategory: #XS
@VDM.viewType: #BASIC
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view ZCDSMM_I_MWSKZVH
  as select from ifitaxcodet
{
  key taxcode     as CodIva,
      taxcodename as Text
}
where
  language = $session.system_language
