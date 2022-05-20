CLASS zcl_mm_nfe_rule_02 DEFINITION
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



CLASS zcl_mm_nfe_rule_02 IMPLEMENTATION.
  METHOD validate.

*Se xPed = EKKO-EBELN, então:
*
*Ler código do fornecedor (EKKO-LIFNR) onde EKKO-EBELN = xPed.
*
*Ler o CNPJ (campo LFA1-STCD1) do fornecedor, onde EKKO-LIFNR = LFA1-LIFNR.
*
*Se CNPJ<emit> <> LFA1-STCD1, então
*
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 0 “Incorreto”
*
*Mensagem de erro: “CNPJ Fornecedor divergente”.
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.


    DATA(s_nfe_data) = go_nfe->get_nfe_data(  ).

    IF ( s_nfe_data-infnfe-emit-cnpj <> gs_det-po-lfa1-stcd1 ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( s_nfe_data-infnfe-emit-cnpj )
       iv_valorsap = CONV #( gs_det-po-lfa1-stcd1 )
      ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
