// Root entity of the model. It´s the header of the transactional data generated during the validation process.

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'XML History Header'
define root view entity ZCDSMM_I_XML_HIST_HD
  as select from ztmm_xml_hist_hd
  composition [0..*] of ZCDSMM_I_XML_HIST_IT  as _Items
  composition [0..*] of zcdsmm_i_xml_hd_cod   as _Cods
  composition [0..*] of ZCDSMM_I_XML_OBSH     as _ObsH
  composition [0..*] of ZCDSMM_I_XML_LOGH     as _LogH
  association [0..1] to ZCDSMM_I_EDOC         as _eDoc    on _eDoc.Accesskey = $projection.Chave
  association [0..*] to ZCDSMM_I_XML_LOG      as _Log     on _Log.Chave = $projection.Chave
  association [0..1] to ZCDSMM_I_XML_LOGH_LAST as _LastLogH on _LastLogH.Chave = $projection.Chave
  association [0..*] to ZCDSMM_I_XML_OBS      as _Obs     on _Obs.Chave = $projection.Chave
  association [0..*] to ZCDSMM_I_LOG_ERROS    as _Errors  on _Errors.Chave = $projection.Chave
{
  key chave                        as Chave,

      status_valid                 as StatusValid,

      file_raw                     as FileRaw,
      xml_str                      as XmlStr,
      credat                       as Credat,
      aezet                        as Aezet,
      aenam                        as Aenam,
      archive                      as Archive,
      status                       as Status,
      cast (cnpj as abap.char(14)) as Cnpj,
      pin                          as Pin,
      action_required              as ActionRequired,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_XML_HD_ATTRS'
      cast ('' as abap.char(30))   as Divergencias,

      ref_xml_str                  as RefXmlStr,
      
      nf_write_docnum              as NfWriteDocnum,

      _Items,
      _Cods,
      _eDoc,
      _Log,
      _LogH,
      _LastLogH,
      _Obs,
      _ObsH,
      _Errors
}
