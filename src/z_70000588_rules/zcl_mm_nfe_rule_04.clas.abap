CLASS zcl_mm_nfe_rule_04 DEFINITION
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



CLASS zcl_mm_nfe_rule_04 IMPLEMENTATION.
  METHOD validate.

*Se xPed = EKKO-EBELN, então:
*
*Ler CNPJ da COIMPA, retorno J_1BREAD_BRANCH_DATA-CGC_NUMBER
*
*Se CNPJ <dest> <> J_1BREAD_BRANCH_DATA-CGC_NUMBER
*
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 0 “Incorreto”
*
*Mensagem de erro: “CNPJ Destino divergente”.
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.

    DATA(v_cnpj_coimpa) = go_nfe->go_branch->get_data(  )-cgc_number.
    DATA(s_nfe_data) = go_nfe->get_nfe_data(  ).
*
    IF ( s_nfe_data-infnfe-dest-cnpj <> v_cnpj_coimpa ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( s_nfe_data-infnfe-dest-cnpj )
       iv_valorsap = CONV #( v_cnpj_coimpa )
      ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
