CLASS zcl_mm_nfe_rule_08 DEFINITION
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



CLASS zcl_mm_nfe_rule_08 IMPLEMENTATION.
  METHOD validate.

*Se xPed = EKPO-EBELN E nItemPed <> EKPO-EBELP OU nItemPed está em branco:
*
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 0 “Incorreto”
*
*Mensagem de erro: “Item de Pedido de Compras Divergente ou em Branco”.
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.

*validar se está vazio
    IF ( gs_det-hist_it-nitemped IS INITIAL ).
      rs_error = fill_error_entity(  ).
      RETURN.
    ENDIF.

*validar contra o EKKO-EBELP
    IF ( gs_det-hist_it-nitemped <> gs_det-po-ekpo-ebelp ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( gs_det-hist_it-nitemped )
      ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
