CLASS zcl_mm_nfe_rule_26 DEFINITION
  PUBLIC
  INHERITING FROM zcl_mm_nfe_rule_gen
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    ALIASES:
        validate FOR zif_mm_nfe_rule~validate.
    METHODS:
      validate REDEFINITION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mm_nfe_rule_26 IMPLEMENTATION.
  METHOD validate.

*Se xPed = EKPO-EBELN E nItemPed = EKPO-EBELP, então:
*
*Verificar se EKPO-MENGE <= qcom.
*
*Se houver divergência, então:
*
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 1 “Atenção”.
*
*Mensagem de erro: “Quantidade divergente”
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.
*
*Com 4 casas decimais, consistir com o PO por item

    DATA v_qcom TYPE bstmg.
    v_qcom = gs_det-prod-qcom.

    IF ( v_qcom > gs_det-vlrs-menge ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( v_qcom )
       iv_valorsap = CONV #( gs_det-vlrs-menge )
      ).
      RETURN.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
