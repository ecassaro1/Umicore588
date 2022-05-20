CLASS zcl_mm_nfe_rule_27 DEFINITION
  PUBLIC
  INHERITING FROM zcl_mm_nfe_rule_gen
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    ALIASES:
        validate FOR zif_mm_nfe_rule~validate.
    METHODS:
      validate REDEFINITION.
  PRIVATE SECTION.
    METHODS:
      inco_format
        IMPORTING
          iv_cod         TYPE j_1bmodfrete_det-modfrete
        RETURNING
          VALUE(rv_desc) TYPE string.
ENDCLASS.



CLASS zcl_mm_nfe_rule_27 IMPLEMENTATION.
  METHOD validate.

*Se xPed = EKKO-EBELN, então:
*
*Ler o valor do campo J_1BMODFRETE_DET-INCO1, onde J_1BMODFRETE_DET-MODFRETE = modFrete
*
*Verificar se EKKO-INCO1 = J_1BMODFRETE_DET-INCO1
*
*Se houver divergência, então:
*
*então
*ZTMM_XML_HIST_HD-STATUS_VALID = 1 “Atenção”.
*
*Mensagem de erro: “Modo do frete divergente”.
*
*Se não ZTMM_XML_HIST_HD-STATUS_VALID = 3 “OK”.

    DATA(v_modfrete_nfe) =
        inco_format(
            CONV #(
                go_nfe->get_nfe_data(  )-infnfe-transp-modfrete
            )
        ).

*    SELECT SINGLE
*        modfrete
*      FROM j_1bmodfrete_det
*      WHERE inco1 = @gs_det-po-ekko-inco1
*      INTO @DATA(v_modfrete_sap).

    IF ( v_modfrete_nfe <> gs_det-po-ekko-inco1 ).
      rs_error = fill_error_entity(
       iv_valorxml = CONV #( v_modfrete_nfe )
       iv_valorsap = CONV #( gs_det-po-ekko-inco1 )
      ).
      RETURN.
    ENDIF.

  ENDMETHOD.

  METHOD inco_format.
    CASE iv_cod.
      WHEN '0'. rv_desc = 'CIF'.
      WHEN '1'. rv_desc = 'FOB'.
      WHEN '2'. rv_desc = 'CIF'.
      WHEN '3'. rv_desc = 'CIF'.
      WHEN '4'. rv_desc = 'FOB'.
      WHEN '9'. rv_desc = 'ZSF'.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
