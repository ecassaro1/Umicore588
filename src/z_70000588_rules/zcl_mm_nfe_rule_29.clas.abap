CLASS zcl_mm_nfe_rule_29 DEFINITION
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



CLASS zcl_mm_nfe_rule_29 IMPLEMENTATION.
  METHOD validate.

    DATA(s_nfe_data) = go_nfe->get_nfe_data(  ).

    IF ( gs_det-po-ekpo-elikz = 'X' ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( '' )
       iv_valorsap = CONV #( '' )
      ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
