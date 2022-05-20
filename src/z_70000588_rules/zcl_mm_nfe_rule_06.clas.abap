CLASS zcl_mm_nfe_rule_06 DEFINITION
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



CLASS zcl_mm_nfe_rule_06 IMPLEMENTATION.
  METHOD validate.

*Se xPed = EKKO-EBELN, então:
*
*Ler CÓDIGO SUFRAMA da COIMPA, retorno  J_1BREAD_BRANCH_DATA-BRANCH_DATA-SUFRAMA
*
*Se ISUF <dest> <> J_1BREAD_BRANCH_DATA-BRANCH_DATA-SUFRAMA
*
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 0 “Incorreto”
*
*Mensagem de erro: “Inscr. SUFRAMA Destino divergente”.
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.

    DATA(v_suframa_coimpa) = go_nfe->go_branch->get_data(  )-branch_data-suframa.
    DATA(s_nfe_data) = go_nfe->get_nfe_data(  ).

    IF go_nfe->gs_nfe_data-infnfe-emit-enderemit-uf EQ 'AM'.
      RETURN.
    ELSEIF go_nfe->gs_nfe_data-infnfe-emit-enderemit-uf NE 'AM' AND
           go_nfe->gs_nfe_data-infnfe-emit-crt EQ '1'.
      RETURN.
    ENDIF.
*
    IF ( s_nfe_data-infnfe-dest-isuf <> v_suframa_coimpa ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( s_nfe_data-infnfe-dest-isuf )
       iv_valorsap = CONV #( v_suframa_coimpa )
      ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
