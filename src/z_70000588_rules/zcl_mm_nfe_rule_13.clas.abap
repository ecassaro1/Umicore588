CLASS zcl_mm_nfe_rule_13 DEFINITION
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



CLASS zcl_mm_nfe_rule_13 IMPLEMENTATION.
  METHOD validate.

*Se xPed = EKPO-EBELN E nItemPed = EKPO-EBELP, então:
*
*Se o valor em vICMS > 0, então, somar o valor de vBC e vICMS.
*
*Senão, usar somente o valor de vBC.
*
*Buscar o valor do campo REGIO da tabela LFA1 onde LFA1-LIFNR = EKKO-LIFNR,
*
*Buscar o valor do campo REGIO da tabela T001W onde EKPO-WERKS = T001W-WERKS
*
*Ler campo KNUMV da tabela EKKO, onde EKKO-EBELN = xPed
*
*
*Ler condições PBXX, ZIIC, ZCIC do item do pedido:
*
*Ler campos KSCHL, KWERT da tabela PRCD_ELEMENTS, onde PRCD_ELEMENTS-KNUMV = EKKO-KNUMV E PRCD_ELEMENTS-KAPPL = ‘M’ E PRCD_ELEMENTS-KSCHL IN (‘PBXX’, ‘ZCIC’, ‘ZIIC’, ‘ZIIP’)
*
*
*Validação 1
*
*Se KWERT < 0:
*
*Case KSCHL = ‘ZCIC’, então:
*
*Verificar PRCD_ELEMENTS-KWERT (para KSCHL de PBXX) é igual a vBC.
*
*Case KSCHL = ‘ZIIC’, então:
*
*Verificar EKPO-NETWR = vBC.
*
*
*Validação 2
*
*Se KWERT = 0 E KSCHL IN (‘ZCIC’, ZIIC’):
*
*Verificar se vBC = 0.
*
*
*Validação 3
*
*Se KWERT > 0 E KSCHL IN (‘ZIIP’):
*
*Verificar se vBC + valor de ZIIP = vBC + vIPI
*
*
*
*
*Validação 4
*
*Se KWERT < 0 E v_dif_st > 0:
*
*Case KSCHL = ‘ZCIC’, então:
*
*Verificar PRCD_ELEMENTS-KWERT + v_dif_st (para KSCHL de PBXX) é igual a vBC + vICMSST
*
*Case KSCHL = ‘ZIIC’, então:
*
*Verificar EKPO-NETWR + v_dif_st = vBC + vICMS
*



*
**se for desonerado não fazer nada disso aqui
*    CHECK ( gs_det-imposto-icms-vicmsdeson IS INITIAL ).
*
**
**Somar o valor a uma variável
*    DATA lv_invalid TYPE boolean.
*    DATA lv_value_xml TYPE p DECIMALS 2.
*    DATA lv_value_sap TYPE p DECIMALS 2.
*    DATA(v_icms_vbc) = char_val_2_dec( CONV #( gs_det-imposto-icms-vbc ) ).
*    DATA(v_icms_vicms) = char_val_2_dec( CONV #( gs_det-imposto-icms-vicms ) ).
*    DATA(v_icms_vicmsst) = char_val_2_dec( CONV #( gs_det-imposto-icms-vicmsst ) ).
*    DATA(v_ipi_vipi) = char_val_2_dec( CONV #( gs_det-imposto-ipi-vipi ) ).
*
**    v_icms_vbc += v_icms_vicms.
*
**    DATA(v_pbxx) = get_prcd_element( 'PBXX' )-kwert. "Preço Brutp
**    DATA(v_zcic) = get_prcd_element( 'ZCIC' )-kwert. "Valor ICMS Cons
**    DATA(v_ziic) = get_prcd_element( 'ZIIC' )-kwert. "Valor ICMS Indus
*    DATA(v_ziip) = get_prcd_element( 'ZIIP' )-kwert. "Valor IPI Indus
*    DATA(v_zcrd) = get_prcd_element( 'ZCRD' )-kwert. "
*    DATA(v_zird) = get_prcd_element( 'ZIRD' )-kwert. "
*
*
***validação #1
**    IF ( v_zcrd <> 0 ).
**      IF ( v_icms_vbc <> v_pbxx ).
**        rs_error = fill_error_entity(
**         iv_valorxml = CONV #( v_icms_vbc )
**         iv_valorsap = CONV #( v_pbxx )
**        ).
**
**        RETURN.
**      ENDIF.
**    ENDIF.
**
**    IF ( v_zird <> 0 ).
**      IF ( v_icms_vbc <> gs_det-po-ekpo-netwr ).
**        rs_error = fill_error_entity(
**         iv_valorxml = CONV #( v_icms_vbc )
**         iv_valorsap = CONV #( v_pbxx )
**        ).
**
**        RETURN.
**      ENDIF.
**    ENDIF.
*
**validação #2
**    IF (
**        ( v_zcic = 0 )
**        OR
**        ( v_ziic = 0 )
**    ).
**      IF ( v_icms_vbc <> 0 ).
**        rs_error = fill_error_entity(
**         iv_valorxml = CONV #( v_icms_vbc )
**         iv_valorsap = CONV #( v_pbxx )
**        ).
**
**        RETURN.
**      ENDIF.
**    ENDIF.
**    DATA(v_zird) = get_prcd_element( EXPORTING iv_kschl = 'ZIRD' "Valor BC ICMS Ind
**                                     CHANGING ev_invalid = lv_invalid )-kwert.
*    IF ( v_icms_vbc > 0 AND
*         v_zird <> 0 AND
*         v_icms_vbc <> v_zird AND
*         lv_invalid IS INITIAL ).
*      lv_value_sap = v_zird.
*      rs_error = fill_error_entity(
*       iv_valorxml = CONV #( v_icms_vbc )
*       iv_valorsap = CONV #( lv_value_sap )
*      ).
*
*      RETURN.
*    ENDIF.
*    CLEAR lv_invalid.
**    DATA(v_zcrp) = get_prcd_element( EXPORTING iv_kschl = 'ZCRD' "Valor BC ICMS Cons
**                                     CHANGING ev_invalid = lv_invalid )-kwert.
*    IF ( v_icms_vbc > 0 AND
*         v_zcrd <> 0 AND
*         v_icms_vbc <> v_zcrd AND
*         lv_invalid IS INITIAL ).
*      lv_value_sap = v_zcrd.
*      rs_error = fill_error_entity(
*       iv_valorxml = CONV #( v_icms_vbc )
*       iv_valorsap = CONV #( lv_value_sap )
*      ).
*
*      RETURN.
*    ENDIF.
*
***validação #3
**    IF ( v_ziip <> 0 ).
**      DATA(v1) = v_icms_vbc + v_ziip.
**      DATA(v2) = v_icms_vbc + v_ipi_vipi.
**      IF ( v1 <> v2 ).
**
***      IF ( v_ziip <> v_ipi_vipi ). "mais simples, eliminando v_icms_vbc de ambos os lados
**        rs_error = fill_error_entity(
**         iv_valorxml = CONV #( v2 )
**         iv_valorsap = CONV #( v1 )
**        ).
**
**        RETURN.
**      ENDIF.
**    ENDIF.
*
***validação #4
**    IF ( v_zcic <> 0 ).
**      DATA(v2) = ( v_icms_vbc + v_icms_vicmsst ).
**
**      IF ( v_zcic <> v2 ).
**        rs_error = fill_error_entity(
**         iv_valorxml = CONV #( v_icms_vbc )
**         iv_valorsap = CONV #( v_pbxx )
**        ).
**
**        RETURN.
**      ENDIF.
**    ENDIF.


*V3
    DATA(v_icms_vicmsdeson) = char_val_2_dec( CONV #( gs_det-imposto-icms-vicmsdeson ) ).
    CHECK ( v_icms_vicmsdeson IS INITIAL ).

    DATA v_value_xml TYPE p DECIMALS 2.
    DATA v_value_sap TYPE p DECIMALS 2.

    DATA(v_icms_vbc) = char_val_2_dec( CONV #( gs_det-imposto-icms-vbc ) ).
    v_value_xml = v_icms_vbc.
    v_value_sap = gs_det-vlrs-icms-bc.

    IF ( v_value_xml <> v_value_sap ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( v_value_xml )
       iv_valorsap = CONV #( v_value_sap )
      ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
