CLASS zcl_mm_nfe_rule_09 DEFINITION
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



CLASS zcl_mm_nfe_rule_09 IMPLEMENTATION.
  METHOD validate.

*Se xPed = EKPO-EBELN E nItemPed = EKPO-EBELP, então:
*
*Verificar se EKPO-TXZ01 = xProd.
*
*Se houver divergência, então:
*
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 1 “Atenção”
*
*Mensagem de erro: “Descrição de Produto divergente”.
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.

    IF ( gs_det-prod-xprod <> gs_det-po-ekpo-txz01 ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( gs_det-prod-xprod )
       iv_valorsap = CONV #( gs_det-po-ekpo-txz01 )
      ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
