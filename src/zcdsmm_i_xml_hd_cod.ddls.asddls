@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view over ZTMM_XML_HD_COD'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcdsmm_i_xml_hd_cod 
as select from ztmm_xml_hd_cod
association to parent ZCDSMM_I_XML_HIST_HD  as _Header
    on $projection.Chave = _Header.Chave
association to ZCDSMM_I_CAD_DIV as MD
    on $projection.CodDiv = MD.CodDiv
{
    key chave as Chave,
    key cod_div as CodDiv,
    MD.NomeDiv as NomeDiv,
    
    _Header
}
