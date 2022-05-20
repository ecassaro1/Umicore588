//This entity represents a NFe document, extracted from the base standard tables
// edocument and edobrincoming which keeps data from the uploaded NFe´s XML. Some
// fields are vitual, extracted at runtime from the XML string itself.

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'eDocument'
define root view entity ZCDSMM_I_EDOC
  as select from edocument     as eDoc
    join         edobrincoming as inc on inc.edoc_guid = eDoc.edoc_guid
  association [0..1] to ZCDSMM_I_XML_HIST_HD           as _xml  on _xml.Chave = $projection.Accesskey
  composition [0..*] of ZCDSMM_I_EDOC_IT               as _Items
  association [0..1] to ZCDSMM_I_EDOCUMENTHISTORY_CANC as _Canc on _Canc.EdocGuid = $projection.EdocGuid
{
  key inc.accesskey                 as Accesskey,
      eDoc.edoc_guid                as EdocGuid,
      inc.nfenum                    as Nfenum,
      inc.series                    as Series,
      eDoc.create_date              as CreateDate,

      inc.company_code              as CompanyCode,

      _xml.ActionRequired           as ActionRequired,
      _xml.Pin                      as Pin,

      cast(
        case
            when _xml.Status = '' then '0'
            when _xml.Status is null then '8'
            else _xml.Status
        end
        as abap.char(1)
      )                             as Status,
      
      _xml.NfWriteDocnum            as NfWriteDocnum,

      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      //      cast ('' as abap.char(1))     as StatusValid,

      cast(
        case
            when _Canc.EdocGuid = '' then _xml.StatusValid
            when _Canc.EdocGuid is null then _xml.StatusValid
            else 'C'
        end
        as abap.char(1)
      )                             as StatusValid,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(2))     as InfnfeIdeCuf,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(60))    as InfnfeIdeNatOp,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(1))     as InfnfeIdeTpnf,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(1))     as InfnfeIdeFinnfe,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(10))    as InfnfeIdeDhemi,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as edoc_accesskey)   as InfnfeIdeNfrefRefnfe,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as edoc_accesskey)   as InfnfeIdeNfrefNnf,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(60))    as InfnfeEmitXnome,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(14))    as InfnfeEmitCnpj,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(14))    as InfnfeEmitIe,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(14))    as InfnfeEmitCrt,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(60))    as InfnfeEmitEnderemitXbairro,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(60))    as InfnfeEmitEnderemitXlgr,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(60))    as InfnfeEmitEnderemitNro,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(60))    as InfnfeEmitEnderemitXcpl,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.numc(8))     as InfnfeEmitEnderemitCep,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.numc(7))     as InfnfeEmitEnderemitCmun,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(60))    as InfnfeEmitEnderemitXmun,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(2))     as InfnfeEmitEnderemitUf,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.numc(4))     as InfnfeEmitEnderemitCpais,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(60))    as InfnfeEmitEnderemitXpais,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(14))    as InfnfeDestCnpj,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(14))    as InfnfeDestIe,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(50))    as EkkoUser,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(100))   as EkkoUserName,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(60))    as InfnfeDestXnome,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(9))     as InfnfeDestEnderDestIsuf,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.numc(1))     as InfnfeTranspModFrete,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(10))    as InfnfeCobrDupDvenc,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(1))     as InfnfeDestCrt,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(60))    as InfnfeTranspTransportaXnome,

      cast ('BRL' as abap.cuky)     as Currency,

      @Semantics.amount.currencyCode: 'Currency'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast (0 as abap.dec( 11, 2 )) as InfNFeTotalIcmstotVnf,
      //
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      //      cast ('' as abap.char(1))     as InfNFeEmitCrtPin,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(14))    as InfnfeTranspTransportaCnpj,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(40))    as InfnfeDestEmail,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(10))    as RefInfnfeIdeDhemi,

      @Semantics.amount.currencyCode: 'Currency'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast (0 as abap.dec( 11, 2 )) as RefInfNFeTotalIcmstotVnf,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as j_1bdocnum)       as RefDocnum,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(60))    as InfnfeEmitEnderemitFone,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_ATTRS'
      cast ('' as abap.char(3))     as POInco1,


      _xml,
      _Items
}
where
  inc.company_code = 'BR05'
