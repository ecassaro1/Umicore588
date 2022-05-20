CLASS zcl_mm_nfe_rule_17 DEFINITION
  PUBLIC
  INHERITING FROM zcl_mm_nfe_rule_gen
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    ALIASES:
        validate FOR zif_mm_nfe_rule~validate.
    METHODS:
      validate REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MM_NFE_RULE_17 IMPLEMENTATION.


  METHOD validate.

*Ler a tabela PRCD_ELEMENTS em memória com as condições ZCIC ZIIC ZCRD ZDE% ZDEV ZIIP ZIRD para cada item do pedido
*Se a quantidade tributada do XML (tag < qTrib>) for maior que a quantidade do pedido, então
*Quantidade a ser calculada = ekpo-menge
*
*
*Valor total da nota fiscal será:
*Se o valor de PRCD_ELEMENTS-KBETR para a condição ZCIC não for igual 0, então
*Vl nota fiscal = ((ekpo-brtwr / ekpo-menge) * valor quantidade calculada) + valor de IPI (ZIIP)
*Else
*Vl nota fiscal = (ekpo-netpr / ekpo-peinh) * valor quantidade calculada
*
*Adicionar valor total da nota fiscal a uma variável para que seja exibida posteriormente em tela


*
**conditions
*    DATA(v_zcic) = get_prcd_element( 'ZCIC' )-kwert.
*    DATA(v_ziic) = get_prcd_element( 'ZIIC' )-kwert.
*    DATA(v_zcrd) = get_prcd_element( 'ZCRD' )-kwert.
*    DATA(v_zde_) = get_prcd_element( 'ZDE%' )-kwert.
*    DATA(v_zdev) = get_prcd_element( 'ZDEV' )-kwert.
*    DATA(v_ziip) = get_prcd_element( 'ZIIP' )-kwert.
*    DATA(v_zird) = get_prcd_element( 'ZIRD' )-kwert.
*
**qtde
*    IF ( gs_det-po-ekpo-menge < gs_det-prod-qtrib ).
*      DATA(v_qtde) = gs_det-po-ekpo-menge.
*    ELSE.
*      v_qtde = gs_det-prod-qtrib.
*    ENDIF.
*
*    IF ( v_zcic <> 0 ).
*      DATA(v_nf) = ( ( ( gs_det-po-ekpo-brtwr / gs_det-po-ekpo-menge ) * v_qtde ) + v_ziip ).
*    ELSE.
*      v_nf = ( ( gs_det-po-ekpo-netpr / gs_det-po-ekpo-peinh ) * v_qtde ).
*    ENDIF.
*
* the code above has been moved to the ZCL_MM_NFE->STD_DATA( ) method


*the validation
*    DATA lv_nfxml TYPE ekpo-brtwr.
*    DATA lv_total_sap TYPE p DECIMALS 2.
*    DATA lv_vl_deson  TYPE ekpo-netpr.
*    data lv_val       type p decimals 6.
*    DATA(s_nfe_data) = go_nfe->get_nfe_data(  ).
*
*    DATA(v_totalnf) = get_prcd_element( iv_kschl ='PBXX' )-kwert.
*
*    LOOP AT go_nfe->gs_nfe_data-infnfe-det INTO DATA(s_det).
*
*      DATA(lv_deson) = s_det-imposto-icms-vicmsdeson.
*      IF lv_deson > 0.
*        lv_val =  s_det-po-ekpo-netpr / s_det-po-ekpo-peinh .
*        lv_val =  lv_val * s_det-po-ekpo-menge.
*        lv_vl_deson = lv_val.
*      ENDIF.
*    ENDLOOP.
*
*    IF lv_vl_deson IS NOT INITIAL.
*      v_totalnf = lv_vl_deson.
*    ENDIF.
*
*
*    "#? é este vnf mesmo (dentro de ICMSTot)? Parece ser o único dentro do layout
**    IF ( s_nfe_data-v_nf <> s_nfe_data-infnfe-total-icmstot-vnf ).
*    IF ( v_totalnf <> s_nfe_data-infnfe-total-icmstot-vnf ).
*      lv_nfxml = s_nfe_data-infnfe-total-icmstot-vnf.
*      rs_error = fill_error_entity(
*       iv_valorxml = CONV #( lv_nfxml )
*       iv_valorsap = CONV #( v_totalnf )
*      ).
*      RETURN.
*    ENDIF.

*v_nf is calculated in ZCL_MM_NFE->STD_DATA( ) method

    DATA(s_nfe_data) = go_nfe->get_nfe_data( ).
    DATA(lv_vnf_xml) =  CONV bbwert( s_nfe_data-infnfe-total-icmstot-vnf ).
    IF ( s_nfe_data-v_nf <> lv_vnf_xml ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( lv_vnf_xml )
       iv_valorsap = CONV #( s_nfe_data-v_nf )
      ).
      RETURN.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
