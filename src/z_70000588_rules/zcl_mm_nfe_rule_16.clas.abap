CLASS zcl_mm_nfe_rule_16 DEFINITION
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



CLASS ZCL_MM_NFE_RULE_16 IMPLEMENTATION.


  METHOD validate.

*Se xPed = EKPO-EBELN E nItemPed = EKPO-EBELP, então:
*
*Ler condições ZDE% e ZDEV do item do pedido:
*
*Ler campo KNUMV da tabela EKKO, onde EKKO-EBELN = xPed
*
*Ler campos KSCHL, KWERT da tabela PRCD_ELEMENTS, onde PRCD_ELEMENTS-KNUMV = EKKO-KNUMV E PRCD_ELEMENTS-KAPPL = ‘M’ E PRCD_ELEMENTS-KSCHL IN (‘ZDEV’, ‘ZDE%’)
*
*Verificar se o valor no campo KWERT, da condition ZDEV ou ZDE% é igual a vDesc
*
*Se houver divergência, então:
*
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 0 “Incorreto”.
*
*Mensagem de erro: “Valor de desconto divergente”
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.

*    DATA(v_prod_vdesc) = char_val_2_dec( CONV #( gs_det-prod-vdesc ) ).
*
*    DATA(v_zde_) = get_prcd_element( 'ZDE%' )-kwert.
*    DATA(v_zdev) = get_prcd_element( 'ZDEV' )-kwert.
*
*    v_zde_ = abs( v_zde_ ).
*    v_zdev = abs( v_zdev ).
*
*    IF ( v_zde_ <> 0 ).
*      IF ( v_prod_vdesc <> v_zde_ ).
*        rs_error = fill_error_entity(
*         iv_valorxml = CONV #( v_prod_vdesc )
*         iv_valorsap = CONV #( v_zde_ )
*        ).
*      ENDIF.
*      RETURN.
*    ENDIF.
*
*    IF ( v_zdev <> 0 ).
*      IF ( v_prod_vdesc <> v_zdev ).
*        rs_error = fill_error_entity(
*         iv_valorxml = CONV #( v_prod_vdesc )
*         iv_valorsap = CONV #( v_zdev )
*        ).
*      ENDIF.
*      RETURN.
*    ENDIF.

*V2
    DATA v_value_xml TYPE p DECIMALS 2.
    DATA v_value_sap TYPE p DECIMALS 2.

    DATA(v_prod_vdesc) = char_val_2_dec( CONV #( gs_det-prod-vdesc ) ).
    v_value_xml = v_prod_vdesc.
    v_value_sap = gs_det-vlrs-descsap-amnt.

    IF ( v_value_xml <> v_value_sap ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( v_value_xml )
       iv_valorsap = CONV #( v_value_sap )
      ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
