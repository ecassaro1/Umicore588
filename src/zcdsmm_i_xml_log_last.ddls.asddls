@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Last log entry of XML_LOG'
define view entity ZCDSMM_I_XML_LOG_LAST
  as select from ZCDSMM_I_XML_LOG          as Log
    join         ZCDSMM_I_XML_LOG_LAST_SEQ as LastSeq on  LastSeq.Chave   = Log.Chave
                                                      and LastSeq.Id      = Log.Id
                                                      and LastSeq.LastSeq = Log.Seq
  association to parent ZCDSMM_I_XML_HIST_IT as _Item on  $projection.Chave = _Item.Chave
                                                      and $projection.Id    = _Item.Id
{
  key Log.Chave,
  key Log.Id,
  key Log.Seq,
      Log.TagXmlHdr,
      Log.TagXmlItem,
      Log.Aedat,
      Log.Aezet,
      Log.Aenam,
      Log.CampoSap,
      Log.StatusValid,
      Log.XPed,
      Log.NItemPed,
      Log.Oldvalue,
      Log.Newvalue,
      Log.TagXmlValor,
      Log.Message,

      /* Associations */
      _Item
}
