CLASS zcl_mm_nfe_rule_01 DEFINITION
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



CLASS zcl_mm_nfe_rule_01 IMPLEMENTATION.
  METHOD validate.

*Pedido de compras
*Tag xPed de <PROD>
*
*Item
*EKKO-EBELN
*Se xPed = EKKO-EBELN OU xPed está em branco:
*
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 0 “Incorreto”
*
*
*Mensagem de erro: “Pedido de Compras Divergente ou em Branco”.
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.

*validar se está vazio
    IF ( gs_det-hist_it-xped IS INITIAL ).
      rs_error = fill_error_entity( ).
      RETURN.
    ENDIF.

*validar contra o EKKO-EBELN
    IF ( gs_det-hist_it-xped <> gs_det-po-ekko-ebeln ).
      rs_error = fill_error_entity(
        iv_valorxml = CONV #( gs_det-hist_it-xped )
        iv_valorsap = CONV #( gs_det-po-ekko-ebeln )
      ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
