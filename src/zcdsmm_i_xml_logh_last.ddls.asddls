@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Last log entry of XML_LOG'
define view entity ZCDSMM_I_XML_LOGH_LAST
  as select from ZCDSMM_I_XML_LOGH          as Log
    join         ZCDSMM_I_XML_LOGH_LAST_SEQ as LastSeq on  LastSeq.Chave   = Log.Chave
                                                       and LastSeq.LastSeq = Log.Seq
  association to parent ZCDSMM_I_XML_HIST_HD as _Header on $projection.Chave = _Header.Chave
{
  key Log.Chave,
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
      _Header
}
