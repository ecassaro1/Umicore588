CLASS zcl_mm_nfe_rule_03 DEFINITION
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



CLASS zcl_mm_nfe_rule_03 IMPLEMENTATION.
  METHOD validate.

*Se xPed = EKKO-EBELN, então:
*
*Ler código do fornecedor (EKKO-LIFNR) onde EKKO-EBELN = xPed.
*
*Ler a IE (campo LFA1-STCD3) do fornecedor, onde EKKO-LIFNR = LFA1-LIFNR.
*
*Se IE<emit> <> LFA1-STCD3, então
*
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 0 “Incorreto”
*
*Mensagem de erro: “IE Fornecedor divergente”.
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.


    DATA(s_nfe_data) = go_nfe->get_nfe_data(  ).

    IF ( s_nfe_data-infnfe-emit-ie <> gs_det-po-lfa1-stcd3 ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( s_nfe_data-infnfe-emit-ie )
       iv_valorsap = CONV #( gs_det-po-lfa1-stcd3 )
      ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
