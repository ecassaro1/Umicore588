@EndUserText.label: 'eDoc Item Consumption'
@AccessControl.authorizationCheck: #CHECK
define view entity ZCDSMM_C_EDOC_IT as projection on ZCDSMM_I_EDOC_IT
{
    key Chave,
    key Id,
    XProd,
    POProd,
    UCom,
    QCom,
    Ncm,
    POMeins,    
    POMenge,
    POTxz01,
    UTrib,    
    QTrib,
    POJ1bnbm,
    IcmsOrig,
    POJ1bmatorg,
    Cfop,
    POJ1bmatuse,
    POMwskz,
    IcmsCst,
    POIcmsCst,
    VUnTrib,
    POWaers,
    PONetpr,
    IcmsVbc,
    PONetwr,
    PIcms,
    POAliqIcms,
    VIcms,
    POVlIcms,
    VIcmsDeson,
    IpiVbc,
    PIpi,
    Vipi,
    PisCst,
    POPisCst,
    CofinsCst,
    POCofinsCst,
    POAliqIpi,
    POVlIpi,
    VProd,
    VDesc,
    POVlDesc,
    POInco1,
    POElikz,
    POMatkl,
    POEindt,
    POWepos,
    POWeunb,
    POAblad,
    POWempf,
    POSakto,
    POKostl,
    POBstae,
    POProcstat,
    POAfnam,
    POKnttp,
    POJ1bindust,
    POWgbez,
    POBcIcms,
    PrUnit,
    
    /* Associations */
    _eDoc
}
