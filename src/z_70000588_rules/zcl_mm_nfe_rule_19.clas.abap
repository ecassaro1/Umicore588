CLASS zcl_mm_nfe_rule_19 DEFINITION
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
    METHODS:
      ncm_mask
        IMPORTING
          iv_source        TYPE ekpo-j_1bnbm
        RETURNING
          VALUE(rv_result) TYPE ekpo-j_1bnbm.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mm_nfe_rule_19 IMPLEMENTATION.
  METHOD validate.

*Se xPed = EKPO-EBELN E nItemPed = EKPO-EBELP, então:
*
*Verificar se EKPO-J_1BNBM = NCM.
*
*Se houver divergência, então:
*
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 1 “Atenção”
*
*Mensagem de erro: “NCM divergente”.
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.

    IF ( strip( CONV #( gs_det-prod-ncm ) ) <> strip( CONV #( gs_det-po-ekpo-j_1bnbm ) ) ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( ncm_mask( CONV #( gs_det-prod-ncm ) ) )
       iv_valorsap = CONV #( gs_det-po-ekpo-j_1bnbm )
      ).
      RETURN.
    ENDIF.

  ENDMETHOD.

  METHOD ncm_mask.
    CHECK ( NOT iv_source IS INITIAL ).
    CHECK ( strlen( iv_source ) >= 8 ).

    rv_result =
        |{ iv_source(4) }.{ iv_source+4(2) }.{ iv_source+6(2) }|.
  ENDMETHOD.
ENDCLASS.
