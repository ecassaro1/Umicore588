@EndUserText.label: 'eDocument Consumption'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define root view entity ZCDSMM_C_EDOC_XLS1
  as projection on ZCDSMM_I_EDOC
{
  key Accesskey,
      Nfenum,
      Series,
      CreateDate,
      CompanyCode,
      EdocGuid,

      //XML entity attrs
      StatusValid, 
      @ObjectModel.text.element: ['ActionRequired'] 
      ActionRequired,
      Pin,
      Status,

      //Virtual attrs
      //@UI.hidden: true

      InfnfeIdeCuf,
      InfnfeIdeNatOp,
      InfnfeIdeTpnf,
      InfnfeIdeFinnfe,
      InfnfeIdeDhemi,
      InfnfeIdeNfrefRefnfe,
      InfnfeIdeNfrefNnf,
      InfnfeEmitXnome,
      InfnfeEmitCnpj,
      InfnfeEmitIe,
      InfnfeEmitCrt,
      InfnfeEmitEnderemitXbairro,
      InfnfeEmitEnderemitXlgr,
      InfnfeEmitEnderemitNro,
      InfnfeEmitEnderemitXcpl,
      InfnfeEmitEnderemitCep,
      InfnfeEmitEnderemitCmun,
      InfnfeEmitEnderemitXmun,
      InfnfeEmitEnderemitUf,
      InfnfeEmitEnderemitCpais,
      InfnfeEmitEnderemitXpais,
      InfnfeDestXnome,
      InfnfeDestCnpj,
      InfnfeDestIe,
      EkkoUser,
      EkkoUserName,
      InfnfeDestEnderDestIsuf,
      InfnfeTranspModFrete,
      InfnfeCobrDupDvenc,
      InfnfeDestCrt,
      InfnfeTranspTransportaXnome, 
      InfNFeTotalIcmstotVnf,
//      InfNFeEmitCrtPin,
      InfnfeTranspTransportaCnpj,
      InfnfeDestEmail,
      RefInfnfeIdeDhemi,
      RefInfNFeTotalIcmstotVnf,
      RefDocnum,
      InfnfeEmitEnderemitFone,
      Currency,
      POInco1,

      _xml,
      _Items: redirected to ZCDSMM_C_EDOC_IT_XLS1 
}
