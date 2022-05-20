// The (errors) log of each ZCDSMM_I_XML_HIST_IT

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Erros Log Interface CDS'
define view entity ZCDSMM_I_LOG_ERROS
  as select from ztmm_log_erros
  association to parent ZCDSMM_I_XML_HIST_IT as _Item   on  $projection.Chave = _Item.Chave
                                                        and $projection.Id    = _Item.Id
  association to ZCDSMM_I_XML_HIST_HD        as _Header on  $projection.Chave = _Header.Chave
{
  key chave                  as Chave,
  key id                     as Id,
  key seq                    as Seq,
      cast( id as abap.int4) as id_sort,
      status_valid           as StatusValid,
      tag_xml_hdr            as TagXmlHdr,
      tag_xml_item           as TagXmlItem,
      n_nf                   as NNf,
      item_xml               as ItemXml,
      pedido                 as Pedido,
      item_pedido            as ItemPedido,
      valor_xml              as ValorXml,
      valor_sap              as ValorSap,
      texto                  as Texto,
      inactive               as Inactive,

      _Item,
      _Header
}
