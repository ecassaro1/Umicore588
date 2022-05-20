CLASS zcl_mm_nfe_rule_12 DEFINITION
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



CLASS ZCL_MM_NFE_RULE_12 IMPLEMENTATION.


  METHOD validate.

*Se xPed = EKPO-EBELN E nItemPed = EKPO-EBELP, então:
*
*
*Se houver divergência, então:
*
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 0 “Incorreto”.
*
*Mensagem de erro: “CST COFINS divergente”
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.

    IF go_nfe->gs_nfe_data-infnfe-emit-crt = '1'.
      RETURN.
    ENDIF.

    DATA(v_law) = get_komv( 'BLCO' )-knuma_bo.

    DATA v_cst TYPE char2.

    SELECT SINGLE
          taxsitout
        INTO @v_cst
        FROM j_1batl4a
        WHERE taxlaw = @v_law.

*    IF ( NOT v_cst IS INITIAL ).
*      CALL FUNCTION 'CONVERSION_EXIT_TXSIT_OUTPUT'
*        EXPORTING
*          input  = v_cst
*        IMPORTING
*          output = v_cst.
*    ENDIF.

    IF ( gs_det-imposto-cofins-cst <> v_cst ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( gs_det-imposto-cofins-cst )
       iv_valorsap = CONV #( v_cst )
      ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
