CLASS zcl_mm_nfe_rule_22 DEFINITION
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



CLASS zcl_mm_nfe_rule_22 IMPLEMENTATION.
  METHOD validate.

*Se xPed = EKPO-EBELN E nItemPed = EKPO-EBELP, então:
*
*Ler condição ZIPI do item do pedido:
*
*Ler campo KNUMV da tabela EKKO, onde EKKO-EBELN = xPed
*
*Ler campos KSCHL, KBETR da tabela PRCD_ELEMENTS, onde PRCD_ELEMENTS-KNUMV = EKKO-KNUMV E PRCD_ELEMENTS-KAPPL = ‘M’ E PRCD_ELEMENTS-KSCHL IN (‘ZIIP’)
*
*Verificar se o valor no campo KWERT é igual a vIPI
*
*Se houver divergência, então:
*
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 0 “Incorreto”.
*
*Mensagem de erro: “Valor IPI divergente”
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.

*
*
*    DATA(v_zxip) = get_prcd_element( 'ZCIP' )-kwert.
*    IF ( v_zxip IS INITIAL ).
*      v_zxip = get_prcd_element( 'ZIIP' )-kwert.
*    ENDIF.
*
*    DATA(v_xml_vipi) = CONV kwert( gs_det-imposto-ipi-vipi ).
*
*    IF ( v_xml_vipi <> v_zxip ).
*      rs_error = fill_error_entity(
*       iv_valorxml = CONV #( v_xml_vipi )
*       iv_valorsap = CONV #( v_zxip )
*      ).
*      RETURN.
*    ENDIF.

*V2
    DATA v_value_xml TYPE p DECIMALS 2.
    DATA v_value_sap TYPE p DECIMALS 2.

    v_value_xml = gs_det-imposto-ipi-vipi.
    v_value_sap = gs_det-vlrs-ipi-amnt.

    IF ( v_value_xml <> v_value_sap ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( v_value_xml )
       iv_valorsap = CONV #( v_value_sap )
      ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
