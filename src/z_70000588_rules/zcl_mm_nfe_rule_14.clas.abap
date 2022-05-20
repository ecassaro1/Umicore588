CLASS zcl_mm_nfe_rule_14 DEFINITION
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



CLASS zcl_mm_nfe_rule_14 IMPLEMENTATION.
  METHOD validate.

*Se xPed = EKPO-EBELN E nItemPed = EKPO-EBELP, então:
*
*Ler condições ZCIC, ZIIC do item do pedido:
*
*Ler campo KNUMV da tabela EKKO, onde EKKO-EBELN = xPed
*
*Ler campos KSCHL, KWERT da tabela PRCD_ELEMENTS, onde PRCD_ELEMENTS-KNUMV = EKKO-KNUMV E PRCD_ELEMENTS-KAPPL = ‘M’ E PRCD_ELEMENTS-KSCHL IN (‘ZCIC’, ZIIC’)
*
*Verificar se o valor no campo KWERT é igual a vICMS
*
*Se houver divergência, então:
*
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 0 “Incorreto”.
*
*Mensagem de erro: “Valor ICMS divergente”
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.

*    DATA(v_deson) =
*        COND #(
*            WHEN ( gs_det-imposto-icms-vicmsdeson > 0 )
*            THEN abap_true
*            ELSE abap_false
*        ).
*
*    SELECT SINGLE
*        *
*      INTO @DATA(s_xml_cfop)
*      FROM ztmm_xml_r_cfop
*      WHERE cfop = @gs_det-prod-cfop
*        AND icms_desonerado = @v_deson.
*
*    IF s_xml_cfop-icms_desonerado = abap_true.
*      RETURN.
*    ENDIF.
*
*    DATA(v_icms_vicms) = char_val_2_dec( CONV #( gs_det-imposto-icms-vicms ) ).
*    DATA(v_zcic) = get_prcd_element( 'ZCIC' )-kwert.
*    v_zcic = ( v_zcic * -1 ).
*    DATA(v_ziic) = get_prcd_element( 'ZIIC' )-kwert.
*    v_ziic = ( v_ziic * -1 ).
*
*    IF ( v_zcic <> 0 ).
*      IF ( v_icms_vicms <> v_zcic ).
*        rs_error = fill_error_entity(
*         iv_valorxml = CONV #( v_icms_vicms )
*         iv_valorsap = CONV #( v_zcic )
*        ).
*      ENDIF.
*      RETURN.
*    ENDIF.
*
*    IF ( v_ziic <> 0 ).
*      IF ( v_icms_vicms <> v_ziic ).
*        rs_error = fill_error_entity(
*         iv_valorxml = CONV #( v_icms_vicms )
*         iv_valorsap = CONV #( v_ziic )
*        ).
*      ENDIF.
*      RETURN.
*    ENDIF.


*V2
    DATA(v_icms_vicmsdeson) = char_val_2_dec( CONV #( gs_det-imposto-icms-vicmsdeson ) ).
    CHECK ( v_icms_vicmsdeson IS INITIAL ).

    DATA v_value_xml TYPE p DECIMALS 2.
    DATA v_value_sap TYPE p DECIMALS 2.

    v_value_xml = gs_det-imposto-icms-vicms.
    v_value_sap = gs_det-vlrs-icms-amnt.

    IF ( v_value_xml <> v_value_sap ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( v_value_xml )
       iv_valorsap = CONV #( v_value_sap )
      ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
