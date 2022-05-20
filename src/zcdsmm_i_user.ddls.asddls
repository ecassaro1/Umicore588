@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User with name'
define root view entity ZCDSMM_I_USER
  as select from usr21
    join         adrp on adrp.persnumber = usr21.persnumber
{
  key usr21.bname    as BName,
      adrp.name_text as NameText
}
