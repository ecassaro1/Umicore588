// The (errors) log of each ZCDSMM_I_XML_HIST_IT

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Erros Log Interface CDS'
define view entity ZCDSMM_I_XML_LOG
  as select from ztmm_xml_log
  association to parent ZCDSMM_I_XML_HIST_IT as _Item   on  $projection.Chave = _Item.Chave
                                                        and $projection.Id    = _Item.Id
  association to ZCDSMM_I_XML_HIST_HD        as _Header on  $projection.Chave = _Header.Chave
{
  key chave         as Chave,
  key id            as Id,
  key seq           as Seq,
      tag_xml_hdr   as TagXmlHdr,
      tag_xml_item  as TagXmlItem,
      aedat         as Aedat,
      aezet         as Aezet,
      aenam         as Aenam,
      campo_sap     as CampoSap,
      status_valid  as StatusValid,
      x_ped         as XPed,
      n_item_ped    as NItemPed,
      oldvalue      as Oldvalue,
      newvalue      as Newvalue,
      tag_xml_valor as TagXmlValor,
      message       as Message,

      _Item,
      _Header
}
