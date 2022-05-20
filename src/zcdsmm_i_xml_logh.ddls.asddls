// The (errors) log of each ZCDSMM_I_XML_HIST_IT

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Erros Log Interface CDS'
define view entity ZCDSMM_I_XML_LOGH
  as select from ztmm_xml_log
  association to parent ZCDSMM_I_XML_HIST_HD as _Header on $projection.Chave = _Header.Chave
{
  key chave         as Chave,
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

      _Header
}
where
  id is initial
