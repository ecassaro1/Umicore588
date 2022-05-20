@EndUserText.label: 'LOG_Erros Consumption'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZCDSMM_C_LOG_ERROS
  as projection on ZCDSMM_I_LOG_ERROS
{
  key Chave,
  key Id,
  key Seq,
      id_sort,
      StatusValid,
      TagXmlHdr,
      TagXmlItem,
      NNf,
      ItemXml,
      Pedido,
      ItemPedido,
      ValorXml,
      ValorSap,
      Texto,
      Inactive,

      /* Associations */
      _Header,
      _Item
}
