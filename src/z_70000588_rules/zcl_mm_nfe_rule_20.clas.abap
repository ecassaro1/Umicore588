CLASS zcl_mm_nfe_rule_20 DEFINITION
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



CLASS zcl_mm_nfe_rule_20 IMPLEMENTATION.
  METHOD validate.

*Se xPed = EKPO-EBELN E nItemPed = EKPO-EBELP, então:
*
*Ler o valor do campo J_1BNFE_MATORG-MATORG, onde J_1BNFE_MATORG-MATORG_XML = orig
*
*Verificar se EKPO-J_1BMATORG IN (J_1BNFE_MATORG- MATORG)
*
*Se houver divergência, então:
*
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 0 “Incorreto”.
*
*Mensagem de erro: “Origem do Material divergente”.
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.



    SELECT SINGLE
            *
        FROM j_1bnfe_matorg
        WHERE matorg_xml = @gs_det-imposto-icms-orig
        INTO @DATA(s_matorg).

    IF ( s_matorg-matorg <> gs_det-po-ekpo-j_1bmatorg ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( s_matorg-matorg )
       iv_valorsap = CONV #( gs_det-po-ekpo-j_1bmatorg )
      ).
      RETURN.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
