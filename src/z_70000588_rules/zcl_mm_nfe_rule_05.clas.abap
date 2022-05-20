CLASS zcl_mm_nfe_rule_05 DEFINITION
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



CLASS zcl_mm_nfe_rule_05 IMPLEMENTATION.
  METHOD validate.

*Se xPed = EKKO-EBELN, então:
*
*Ler IE da COIMPA, retorno  J_1BREAD_BRANCH_DATA-BRANCH_DATA-STATE_INSC
*
*Se IE <dest> <> J_1BREAD_BRANCH_DATA-BRANCH_DATA-STATE_INSC
*
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 0 “Incorreto”
*
*Mensagem de erro: “IE Destino divergente”.
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.


    DATA(v_ie_coimpa) = go_nfe->go_branch->get_data(  )-branch_data-state_insc.
    DATA(s_nfe_data) = go_nfe->get_nfe_data(  ).
*
    IF ( s_nfe_data-infnfe-dest-ie <> v_ie_coimpa ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( s_nfe_data-infnfe-dest-ie )
       iv_valorsap = CONV #( v_ie_coimpa )
      ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
