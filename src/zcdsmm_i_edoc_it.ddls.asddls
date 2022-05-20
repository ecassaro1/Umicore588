// Items of ZCDSMM_I_EDOC. The fields are extracted from the XML string at runtime.

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'eDoc Item'
define view entity ZCDSMM_I_EDOC_IT
  as select from ZCDSMM_I_XML_HIST_IT
  association to parent ZCDSMM_I_EDOC as _eDoc on _eDoc.Accesskey = $projection.Chave
{
  key Chave,
  key Id, 

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as abap.char(120))      as XProd,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as maktx)               as POProd,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as bstme)               as UCom,
      @Semantics.quantity.unitOfMeasure: 'UCom'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.dec( 11, 4 ))    as QCom,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as bstme)               as POMeins,
      @Semantics.quantity.unitOfMeasure: 'POMeins'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as bstmg)                as POMenge,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as abap.char(8))        as Ncm,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as txz01)                as POTxz01,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(3))         as UTrib,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(16))        as QTrib,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as j_1bnbmco1)           as POJ1bnbm,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(3))         as IcmsOrig,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(3))         as POJ1bmatorg,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(4))         as Cfop,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(60))        as POJ1bmatuse,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(3))         as POMwskz,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(22))        as VUnTrib,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as waers)               as POWaers,

      @Semantics.amount.currencyCode: 'POWaers'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as bprei)                as PONetpr,

      @Semantics.amount.currencyCode: 'POWaers'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as bprei)                as PONetwr,

      //ICMS
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(16))        as IcmsVbc,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(8))         as PIcms,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(16))        as VIcms,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(16))        as VIcmsDeson,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(3))         as IcmsCst,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(3))         as POIcmsCst,

      @Semantics.amount.currencyCode: 'POWaers'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as vfprc_element_amount) as POAliqIcms,

      @Semantics.amount.currencyCode: 'POWaers'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as vfprc_element_value)  as POVlIcms,

      //IPI
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(16))        as IpiVbc,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(8))         as PIpi,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(16))        as Vipi,

      //PIS
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(3))         as PisCst,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(3))         as POPisCst,

      //Cofins
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(3))         as CofinsCst,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as abap.char(3))         as POCofinsCst,

      @Semantics.amount.currencyCode: 'POWaers'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as vfprc_element_amount) as POAliqIpi,

      @Semantics.amount.currencyCode: 'POWaers'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as vfprc_element_value)  as POVlIpi,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as abap.char(16))       as VProd,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as abap.char(16))       as VDesc,

      @Semantics.amount.currencyCode: 'POWaers'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as vfprc_element_value)  as POVlDesc,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as abap.char(3))        as POInco1,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as abap.char(3))        as POElikz,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as matkl)               as POMatkl,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as char10)              as POEindt,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as abap.char(3))        as POWepos,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as abap.char(3))        as POWeunb,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as ablad)               as POAblad,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as wempf)               as POWempf,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as sakto)               as POSakto,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as kostl)               as POKostl,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as bsbez)               as POBstae,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as meprocstate)         as POProcstat,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as afnam)               as POAfnam,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      //      cast ('' as knttp)               as POKnttp,
      cast (0 as abap.char(60))        as POKnttp,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      //      cast ('' as j_1bindus3)          as POJ1bindust,
      cast (0 as abap.char(60))        as POJ1bindust,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as wgbez)               as POWgbez,

      @Semantics.amount.currencyCode: 'POWaers'
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast (0 as vfprc_element_value)  as POBcIcms,

      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_MM_EDOC_IT_ATTRS'
      cast ('' as abap.char(16))       as PrUnit,

      /* Associations */
      _eDoc
}
