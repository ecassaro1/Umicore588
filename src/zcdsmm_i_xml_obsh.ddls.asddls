@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Observations'
define view entity ZCDSMM_I_XML_OBSH
  as select from ztmm_xml_obsh
  association to parent ZCDSMM_I_XML_HIST_HD as _Header on $projection.Chave = _Header.Chave
  association to ZCDSMM_I_USER               as User    on $projection.Aenam = User.BName
{
  key chave         as Chave,
  key aedat         as Aedat,
  key aezet         as Aezet,
      aenam         as Aenam,
      User.NameText as UserName,
      message       as Message,

      _Header
}
