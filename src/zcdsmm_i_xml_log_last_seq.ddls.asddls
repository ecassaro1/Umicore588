@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Last SEQ for ZCDSMM_I_XML_LOG by CHAVE & Id'
define view entity ZCDSMM_I_XML_LOG_LAST_SEQ
as select from ZCDSMM_I_XML_LOG
{
    key Chave,
    key Id,
    max(Seq) as LastSeq
}
group by Chave, Id;
