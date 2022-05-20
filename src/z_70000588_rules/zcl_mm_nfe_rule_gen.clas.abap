***
* Abstract class over the interface implementing the constructor. To be inherited
* by all validation rule sub classes, for instance: ZCL_MM_NFE_RULE_01, ..._02, etc.
***

CLASS zcl_mm_nfe_rule_gen DEFINITION
  ABSTRACT
  PUBLIC.

  PUBLIC SECTION.

    INTERFACES zif_mm_nfe_rule ALL METHODS ABSTRACT.

    METHODS:
      constructor
        IMPORTING
          io_nfe   TYPE REF TO zcl_mm_nfe
          iv_id    TYPE zcdsmm_i_xml_hist_it-id
          is_regra TYPE zcdsmm_i_xml_regra.
  PROTECTED SECTION.
    DATA:
      go_nfe   TYPE REF TO zcl_mm_nfe,
      gv_id    TYPE zcdsmm_i_xml_hist_it-id,
      gs_regra TYPE zcdsmm_i_xml_regra,
      gs_det   TYPE zcl_mm_nfe=>y_det.

    CLASS-METHODS:
      char_val_2_dec
        IMPORTING
          iv_str_val        TYPE string
        RETURNING
          VALUE(rv_dec_val) TYPE ekpo-netwr.

    METHODS:
      fill_error_entity
        IMPORTING
          iv_valorxml     TYPE zcdsmm_i_log_erros-valorxml  OPTIONAL
          iv_valorsap     TYPE zcdsmm_i_log_erros-valorsap  OPTIONAL
        RETURNING
          VALUE(rs_error) TYPE zcdsmm_i_log_erros,

      get_prcd_element
        IMPORTING
          iv_kschl               TYPE prcd_elements-kschl
        CHANGING
          ev_invalid             TYPE boolean OPTIONAL
        RETURNING
          VALUE(rs_prcd_element) TYPE prcd_elements,

      get_komv
        IMPORTING
          iv_kschl       TYPE komv-kschl
        RETURNING
          VALUE(rs_komv) TYPE komv,

      strip
        IMPORTING
          iv_source        TYPE string
          iv_char          TYPE char1
            OPTIONAL
        RETURNING
          VALUE(rv_result) TYPE string.

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mm_nfe_rule_gen IMPLEMENTATION.
  METHOD constructor.
    go_nfe = io_nfe.
    gv_id = iv_id.
    gs_regra = is_regra.

    gs_det = go_nfe->item_fetch( gv_id ).
  ENDMETHOD.

  METHOD fill_error_entity.
    DATA(s_nfe_data) = go_nfe->get_nfe_data(  ).
    DATA(s_det) = go_nfe->item_fetch( gv_id ).

    rs_error-chave = go_nfe->gv_accesskey.
    rs_error-id = gv_id.
    rs_error-statusvalid = gs_regra-statusvalid.
    rs_error-tagxmlhdr = gs_regra-tagxmlhdr.
    rs_error-tagxmlitem = gs_regra-tagxmlitem.
    rs_error-itemxml = s_det-prod-nitem.
    rs_error-pedido = s_det-hist_it-xped.
    rs_error-itempedido = s_det-hist_it-nitemped.
    rs_error-valorxml = iv_valorxml.
    rs_error-valorsap = iv_valorsap.
    rs_error-texto = gs_regra-message.

    rs_error-nnf = go_nfe->get_value( 'cNF' ).

    SELECT SINGLE
        nfenum
        FROM zcdsmm_i_edoc
        WHERE accesskey = @go_nfe->gv_accesskey
        INTO @rs_error-nnf.
  ENDMETHOD.

  METHOD char_val_2_dec.
    rv_dec_val = iv_str_val.
  ENDMETHOD.

  METHOD get_prcd_element.
    TRY.
        rs_prcd_element =
            gs_det-po-t_prcd_elements[
                kappl = 'M'
                kschl = iv_kschl
            ].
      CATCH cx_sy_itab_line_not_found.
        ev_invalid = abap_true.
    ENDTRY.
  ENDMETHOD.

  METHOD get_komv.
    TRY.
        rs_komv =
            gs_det-po-t_komv[
                kappl = 'TX'
                kschl = iv_kschl
            ].
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.
  ENDMETHOD.

  METHOD strip.
    IF ( iv_char IS SUPPLIED ).
      DATA(v_char) = iv_char.
    ELSE.
      v_char = '.'. "default
    ENDIF.

    rv_result = iv_source.

    REPLACE ALL OCCURRENCES OF
        v_char
        IN rv_result
        WITH space.
  ENDMETHOD.

ENDCLASS.
