@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Last SEQ for ZCDSMM_I_XML_LOGH by CHAVE'
define view entity ZCDSMM_I_XML_LOGH_LAST_SEQ
as select from ZCDSMM_I_XML_LOGH
{
    key Chave,
    max(Seq) as LastSeq
}
group by Chave;
