CLASS zcl_mm_nfe_rule_07 DEFINITION
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



CLASS zcl_mm_nfe_rule_07 IMPLEMENTATION.


  METHOD validate.

*Se xPed = EKPO-EBELN E nItemPed = EKPO-EBELP, então:
*
*Ler condições ZCIC, ZIIC do item do pedido:
*
*Ler campo KNUMV da tabela EKKO, onde EKKO-EBELN = xPed
*
*Ler campos KSCHL, KBETR da tabela PRCD_ELEMENTS,
*onde PRCD_ELEMENTS-KNUMV = EKKO-KNUMV
*E PRCD_ELEMENTS-KAPPL = ‘M’ E PRCD_ELEMENTS-KSCHL IN (‘ZCIC’, ZIIC’)
*
*Verificar se o valor no campo KBETR (convertido em %-) é igual a pICMS
*
*Se houver divergência, então:
*
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 0 “Incorreto”.
*
*Mensagem de erro: “Alíq. ICMS divergente”
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.


*    TRY.
*        DATA(v_zcic) =
*            gs_det-po-t_prcd_elements[
*                kappl = 'M'
*                kschl = 'ZCIC'
*            ]-kbetr.
*      CATCH cx_sy_itab_line_not_found.
*    ENDTRY.

*    TRY.
*        DATA(v_ziic) =
*            gs_det-po-t_prcd_elements[
*                kappl = 'M'
*                kschl = 'ZIIC'
*            ]-kbetr.
*      CATCH cx_sy_itab_line_not_found.
*    ENDTRY.

*V2
*    DATA lv_invalid TYPE boolean.
*    DATA lv_value_xml TYPE p DECIMALS 2.
*    DATA lv_value_sap TYPE p DECIMALS 2.
*    DATA(v_zcic) = get_prcd_element( EXPORTING iv_kschl ='ZCIC'
*                                     CHANGING ev_invalid = lv_invalid )-kbetr.
*
*    DATA(v_icms_vicmsdeson) = char_val_2_dec( CONV #( gs_det-imposto-icms-vicmsdeson ) ).
*    CHECK ( v_icms_vicmsdeson = 0 ).
*
*    IF ( gs_det-imposto-icms-picms <> v_zcic AND
*        lv_invalid                 IS INITIAL ).
*      lv_value_xml = gs_det-imposto-icms-picms.
*      lv_value_sap = v_zcic.
*      rs_error = fill_error_entity(
*       iv_valorxml = CONV #( lv_value_xml )
*       iv_valorsap = CONV #( lv_value_sap )
*      ).
*      RETURN.
*    ENDIF.
*
*    CLEAR lv_invalid.
*    DATA(v_ziic) = get_prcd_element( EXPORTING iv_kschl = 'ZIIC'
*                                     CHANGING ev_invalid = lv_invalid )-kbetr.
*
*    IF ( gs_det-imposto-icms-picms <> v_ziic AND
*         lv_invalid                IS INITIAL ).
*      lv_value_xml = gs_det-imposto-icms-picms.
*      lv_value_sap = v_ziic.
*      rs_error = fill_error_entity(
*       iv_valorxml = CONV #( lv_value_xml )
*       iv_valorsap = CONV #( lv_value_sap )
*      ).
*    ENDIF.


*V3
    DATA(v_icms_vicmsdeson) = char_val_2_dec( CONV #( gs_det-imposto-icms-vicmsdeson ) ).
    CHECK ( v_icms_vicmsdeson IS INITIAL ).

    DATA v_value_xml TYPE p DECIMALS 2.
    DATA v_value_sap TYPE p DECIMALS 2.

    v_value_xml = gs_det-imposto-icms-picms.
    v_value_sap = gs_det-vlrs-icms-aliq.

    IF ( v_value_xml <> v_value_sap ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( v_value_xml )
       iv_valorsap = CONV #( v_value_sap )
      ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
